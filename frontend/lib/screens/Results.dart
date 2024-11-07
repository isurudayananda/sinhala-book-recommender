// Results.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BookDetails.dart';

class ResultsPage extends StatefulWidget {
  final String searchQuery;

  const ResultsPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/books/search'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {'query': widget.searchQuery},
    );

    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body);
        _searchResults = List<Map<String, dynamic>>.from(data.map((book) {
          return {
            'Book_Name': book['book_name'],
            'ISBN': book['isbn'],
            'Author': book['author'],
            'Category': book['categories'],
            'URL': book['url'],
            'image_url': book['img_url']
          };
        }));
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSimilarBooks(String bookName) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/books/get-similar'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {'book_name': bookName},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load similar books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Results"),
      ),
      body: _searchResults.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final book = _searchResults[index];
                return ListTile(
                  title: Text(book['Book_Name'] ?? 'Unknown Title'),
                  subtitle: Text(book['Author'] ?? 'Unknown Author'),
                  leading: book['image_url'] != null
                      ? Image.network(book['image_url'], width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.book, size: 50),
                  onTap: () async {
                    try {
                      final similarBooks = await fetchSimilarBooks(book['Book_Name']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetails(book: book, similarBooks: similarBooks),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error fetching similar books: $e')),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
