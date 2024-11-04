import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'LoginPage.dart';

class BookDetails extends StatelessWidget {
  final Map<String, dynamic> book;
  final List<Map<String, dynamic>> similarBooks;

  const BookDetails({Key? key, required this.book, required this.similarBooks}) : super(key: key);

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open the link")),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['Book_Name'] ?? 'Unknown Book'), // Handle null title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            Center(
              child: Image.network(
                book['image_url'] ?? '',
                height: 250,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, size: 150);
                },
              ),
            ),
            const SizedBox(height: 20),
            // Book Title
            Text(
              book['Book_Name'] ?? 'Unknown Book', // Handle null title
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Book Author
            Row(
              children: [
                const Text(
                  "Author: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  book['Author'] ?? 'Unknown',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Book ISBN
            Row(
              children: [
                const Text(
                  "ISBN: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  book['ISBN']?.toString() ?? 'N/A', // Handle null ISBN
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Book Category
            Row(
              children: [
                const Text(
                  "Category: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  book['Category'] ?? 'Not specified',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Buy Link Button
                ElevatedButton(
                  onPressed: () {
                    _launchURL(context, book['URL'] ?? ''); // Handle null URL
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 10, 10, 10).withOpacity(0.1),
                    foregroundColor: const Color.fromARGB(255, 47, 3, 245),
                  ),
                  child: const Text("Buy Now"),
                ),
                // Log Out Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(), // Replace with your login page widget
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 10, 10, 10).withOpacity(0.1),
                    foregroundColor: const Color.fromARGB(255, 47, 3, 245),
                  ),
                  child: const Text("Log Out"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Similar Books Section
            const Text(
              "Similar Books",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Similar Books Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: similarBooks.length,
                itemBuilder: (context, index) {
                  final similarBook = similarBooks[index];
                  return GestureDetector(
                    onTap: () async {
                      // populate similar books
                      var similar = await fetchSimilarBooks(similarBook['Book_Name']).then((value) => value);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetails(book: similarBook, similarBooks: similar), // Pass empty for further similar books
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: Image.network(
                              similarBook['image_url'] ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image, size: 100);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              similarBook['Book_Name'] ?? 'Unknown', // Handle null name
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
          ],
        ),
      ),
    );
  }
}
