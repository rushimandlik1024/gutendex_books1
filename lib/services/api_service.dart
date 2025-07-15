
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static Future<Map<String, dynamic>> fetchBooks({
    required String category,
    String search = '',
    String? urlOverride,
  }) async {
    String url = urlOverride ??
        'http://skunkworks.ignitesol.com:8000/books?topic=$category&mime_type=image/';

    if (search.isNotEmpty) {
      url += '&search=$search';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<Book> books = (json['results'] as List)
          .map((bookJson) => Book.fromJson(bookJson))
          .toList();

      return {
        'books': books,
        'next': json['next'],
      };
    } else {
      throw Exception('Failed to load books');
    }
  }
}
