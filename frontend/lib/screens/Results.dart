// Results.dart

import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final String searchQuery;

  const ResultsPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Results"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Results for: $searchQuery",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
