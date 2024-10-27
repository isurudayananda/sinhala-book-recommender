import 'package:flutter/material.dart';
import 'BookDetails.dart'; // Import the BookDetails page

class HomePage extends StatefulWidget {
  final List<String> preferences; // Accept preferences as user input

  const HomePage({Key? key, required this.preferences}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _books = [
    {'title': 'Senkottan', 'image': 'assets/images/senkottan.jpg', 'rating': 4.5},
    {'title': 'Manikkawatha', 'image': 'assets/images/manikkawatha.jpg', 'rating': 4.7},
    {'title': 'Madol Duwa', 'image': 'assets/images/madol_duwa.jpg', 'rating': 4.8},
  ];

  // Filter books based on user preferences
  List<Map<String, dynamic>> _getRecommendedBooks() {
    return _books.where((book) => widget.preferences.contains(book['title'])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Book Recommender"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Recommender"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRecommenderTab(),
          ],
        ),
      ),
    );
  }

  // Recommender Tab
  Widget _buildRecommenderTab() {
    final recommendedBooks = _getRecommendedBooks();

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 books per row
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 2 / 3, // Aspect ratio for the book cover
      ),
      itemCount: recommendedBooks.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            // Navigate to BookDetails when tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetails(book: recommendedBooks[index]),
              ),
            );
          },
          child: Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Image.asset(
                    recommendedBooks[index]['image'],
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    recommendedBooks[index]['title'],
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
    );
  }
}
