import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'BookDetails.dart';
import 'Results.dart'; // Import Results page
import 'LoginPage.dart'; // Import LoginPage for logout functionality
import 'package:provider/provider.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.preferences}) : super(key: key);

  final List<String> preferences;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _books = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<List<Map<String, dynamic>>> fetchSimilarBooks(String bookName) async {
    var dio = Dio();
    try {
      final response = await dio.post(
        'http://localhost:8000/api/books/get-similar',
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
        data: {'book_name': bookName},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load similar books');
      }
    } catch (e) {
      throw Exception('Error fetching similar books: $e');
    }
  }

  Future<void> _fetchRecommendations() async {
    final token = Provider.of<AuthState>(context, listen: false).token;
    if (token == null) {
      _showSnackBar('Authentication required');
      return;
    }

    try {
      var dio = Dio();
      final response = await dio.get(
        'http://localhost:8000/api/books/get-recommendations',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Wrap the data in a list if the response is a single object
        final books = data is List ? data : [data];

        setState(() {
          _books = books.map((book) {
            return {
              'Book_Name': book['Book_Name'],
              'ISBN': book['ISBN'],
              'Author': book['Author'],
              'Category': book['Category'],
              'URL': book['URL'],
              'image_url': book['image_url'],
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        _showSnackBar('Failed to fetch recommendations');
      }
    } catch (e) {
      _showSnackBar('Error fetching recommendations: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sinhala Book Recommender"),
      ),
      body: _isLoading ? _buildLoading() : _buildRecommenderTab(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildRecommenderTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field and button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search categories",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  final query = _searchController.text;
                  if (query.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsPage(searchQuery: query),
                      ),
                    );
                  }
                },
                child: const Text("Search"),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Here's your book recommendations",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 2 / 3,
            ),
            itemCount: _books.length,
            itemBuilder: (BuildContext context, int index) {
              final book = _books[index];
              return GestureDetector(
                onTap: () async {
                  try {
                    List<Map<String, dynamic>> similarBooks = await fetchSimilarBooks(book['Book_Name']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetails(book: book, similarBooks: similarBooks),
                      ),
                    );
                  } catch (e) {
                    _showSnackBar('Error fetching similar books: $e');
                  }
                },
                child: Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Image.network(
                          book['image_url'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          book['Book_Name'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Log Out Button
        Center(
          child: ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
            ),
            child: const Text("Log Out", style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 20), // Additional spacing for layout
      ],
    );
  }
}
