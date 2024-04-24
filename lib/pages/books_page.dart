import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:book_app/db/book_database.dart';
import 'package:book_app/model/book.dart';
import 'package:book_app/pages/edit_book_page.dart';
import 'package:book_app/widget/book_card.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late List<Book> books;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshBooks();
  }

  void refreshBooks() async {
    setState(() => isLoading = true);

    List<Book> list = await BookDatabase.instance.readAllBooks();

    setState(() {
      isLoading = false;
      books = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Books',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditBookPage(),
            )
          );

          refreshBooks();
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: isLoading ? const CircularProgressIndicator()
          : books.isEmpty ? const Text(
            'No Books',
            style: TextStyle(
              color: Colors.white
            ),
          )
          : buildBooks()
        ),
      ),
    );
  }

  Widget buildBooks() => StaggeredGrid.count(
    crossAxisCount: 2,
    mainAxisSpacing: 2,
    crossAxisSpacing: 2,
    children: List.generate(books.length, (index) {
      Book book = books[index];
      return StaggeredGridTile.fit(
        crossAxisCellCount: 1,
        child: BookCard(book, update: refreshBooks,),
      );
    }),
  );
}