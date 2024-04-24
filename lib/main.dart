import 'package:flutter/material.dart';
import 'package:book_app/pages/books_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BOOK APP',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.blueGrey[900],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.white
          )
        ),
        useMaterial3: true,
      ),
      home: const BookPage(),
    );
  }
}