import 'package:flutter/material.dart';
import 'package:google_books/search_page.dart';

void main() {
  runApp(const GoogleBooksApp());
}

class GoogleBooksApp extends StatefulWidget {
  const GoogleBooksApp({Key? key}) : super(key: key);

  @override
  GoogleBooksAppState createState() => GoogleBooksAppState();
}

class GoogleBooksAppState extends State<GoogleBooksApp> {
  final String title = 'Google Books';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: SearchPage(title),
    );
  }
}
