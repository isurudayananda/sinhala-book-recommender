import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetails extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetails({Key? key, required this.book}) : super(key: key);

  // Method to open the URL link in a browser
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            Center(
              child: Image.asset(
                book['image'],
                height: 250,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            // Book Title
            Text(
              book['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Book Rating
            Row(
              children: [
                const Text(
                  "Rating: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  book['rating'].toString(),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Book Author
            Row(
              children: const [
                Text(
                  "Author: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Mahinda Prasad Masimbula",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Book ISBN
            Row(
              children: const [
                Text(
                  "ISBN: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "9789550980000",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Book Categories
            Row(
              children: const [
                Text(
                  "Categories: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sinhala Literature",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Buy Link
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _launchURL(context, "https://grantha.lk/senkottan-mahinda-prasad-masimbula-santhawa-prakashana.html");
                },
                style: ElevatedButton.styleFrom(
                   backgroundColor:  const Color.fromARGB(255, 10, 10, 10).withOpacity(0.1),
                  foregroundColor: const Color.fromARGB(255, 47, 3, 245),
                ),
                child: const Text("Buy Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
