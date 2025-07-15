
import 'package:flutter/material.dart';
import 'books_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> categories = const [
    'Fiction',
    'Science',
    'Fantasy',
    'History',
    'Children',
    'Mystery',
    'Romance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gutendex Library')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        BooksListScreen(category: categories[index]),
                  ),
                );
              },
              child: Text(categories[index]),
            ),
          );
        },
      ),
    );
  }
}
