import 'package:flutter/material.dart';
import '../models/book.dart';

class BookTile extends StatelessWidget {
  final Book book;

  const BookTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        // ✅ CHANGE #1: Check if image is available
        leading: book.coverImage != null
            ? Image.network(
          book.coverImage!,
          width: 60,
          height: 80,
          fit: BoxFit.cover,
          // ✅ CHANGE #2: Handle image errors gracefully
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported, size: 60);
          },
        )
            : const Icon(Icons.image_not_supported, size: 60),
        title: Text(book.title),
        subtitle: Text(book.authors.join(', ')),
      ),
    );
  }
}
