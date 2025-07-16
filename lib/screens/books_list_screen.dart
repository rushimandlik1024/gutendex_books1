import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../widgets/book_tile.dart';

class BooksListScreen extends StatefulWidget {
  final String category;

  const BooksListScreen({super.key, required this.category});

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Book> books = [];
  String? nextUrl;
  bool isLoading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchBooks();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300 &&
          nextUrl != null &&
          !isLoading) {
        fetchBooks(url: nextUrl!);
      }
    });
  }

  Future<void> fetchBooks({String? url}) async {
    setState(() => isLoading = true);

    final response = await ApiService.fetchBooks(
      category: widget.category,
      search: searchQuery,
      urlOverride: url,
    );

    setState(() {
      books.addAll(response['books']);
      nextUrl = response['next'];
      isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      books.clear();
      nextUrl = null;
      searchQuery = value;
    });
    fetchBooks();
  }

  void _openBook(Book book) {
    final formats = book.formats;

    String? bookUrl = formats['text/html'] ??
        formats['application/pdf'] ??
        formats['text/plain'];

    if (bookUrl != null && !bookUrl.endsWith('.zip')) {
      launchUrl(Uri.parse(bookUrl), mode: LaunchMode.externalApplication);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('No viewable version available'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title or author...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: books.length + (isLoading ? 1 : 0),
              padding: const EdgeInsets.only(bottom: 16),
              itemBuilder: (context, index) {
                if (index < books.length) {
                  return GestureDetector(
                    onTap: () => _openBook(books[index]),
                    child: BookTile(book: books[index]),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
