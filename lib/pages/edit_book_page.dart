import 'package:flutter/material.dart';
import 'package:book_app/db/book_database.dart';
import 'package:book_app/model/book.dart';

class AddEditBookPage extends StatefulWidget {
  final Book? book;
  const AddEditBookPage({this.book, super.key});

  @override
  State<AddEditBookPage> createState() => _AddEditBookPageState();
}

class _AddEditBookPageState extends State<AddEditBookPage> {
  final _formkey = GlobalKey<FormState>();
  late String onChangedTitle;
  late String onChangedDescription;
  late String onChangedBookImage;

  @override
  void initState() {
    super.initState();
    onChangedTitle = widget.book?.title ?? '';
    onChangedDescription = widget.book?.description ?? '';
    onChangedBookImage = widget.book?.bookImage ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarTextStyle: const TextStyle(color: Colors.white),
        actions: [
          saveButton(),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
            key: _formkey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(children: [
                TextFormField(
                  initialValue: widget.book?.title,
                  validator: (value) {
                    if (value != null && value.isEmpty)
                      return 'Title cannot be empty';
                    return null;
                  },
                  onChanged: (title) {
                    setState(() {
                      onChangedTitle = title;
                    });
                  },
                  decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white30),
                      contentPadding: EdgeInsets.zero),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  maxLines: null,
                  initialValue: widget.book?.description,
                  validator: (value) {
                    if (value != null && value.isEmpty)
                      return 'Book cannot be empty';
                    return null;
                  },
                  onChanged: (descrption) {
                    setState(() {
                      onChangedDescription = descrption;
                    });
                  },
                  decoration: const InputDecoration(
                      hintText: 'Your Book Here...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white30),
                      contentPadding: EdgeInsets.zero),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                TextFormField(
                  initialValue: widget.book?.bookImage,
                  onChanged: (bookImage) {
                    setState(() {
                      onChangedBookImage = bookImage;
                    });
                  },
                  decoration: const InputDecoration(
                      hintText: 'Book Image',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white30),
                      contentPadding: EdgeInsets.zero),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                )
              ]),
            )),
      ),
    );
  }

  Widget saveButton() {
    return IconButton(
        onPressed: () {
          bool isValid = _formkey.currentState!.validate();
          if (isValid) {
            if (widget.book != null) {
              Book updated = widget.book!.copy(
                title: onChangedTitle,
                description: onChangedDescription,
              );

              print({'updated book is: id ${widget.book!.id}'});

              BookDatabase.instance.update(updated);
            } else {
              BookDatabase.instance.create(Book(
                  title: onChangedTitle,
                  description: onChangedDescription,
                  bookImage: onChangedBookImage,
                  createdTime: DateTime.now()));
            }
            Navigator.pop(context);
          }
        },
        icon: const Icon(Icons.save));
  }
}
