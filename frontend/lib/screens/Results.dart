// Results.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultsPage extends StatefulWidget {
  final String searchQuery;

  const ResultsPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<dynamic> _searchResults = [];

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
        _searchResults = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load search results');
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
                  title: Text(book['name'] ?? 'Unknown Title'),
                  subtitle: Text(book['author'] ?? 'Unknown Author'),
                );
              },
            ),
    );
  }
}
