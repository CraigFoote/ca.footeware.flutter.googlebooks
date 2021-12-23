import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'book.dart';
import 'book_card.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage(this.searchString, {Key? key}) : super(key: key);
  final String searchString;

  @override
  State<StatefulWidget> createState() => SearchResultsPageState();
}

class SearchResultsPageState extends State<SearchResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Google Books - Search Results for '" + widget.searchString + "'"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<ListView>(
          future: getSearchResults(widget.searchString),
          builder: (BuildContext context, AsyncSnapshot<ListView> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.data == null) {
              return const Text('No search results found.');
            } else {
              var result = snapshot.data!;
              return result;
            }
          },
        ),
      ),
    );
  }
}

Future<ListView> getSearchResults(String searchString) async {
  Uri uri = Uri(
      scheme: 'https',
      host: 'www.googleapis.com',
      path: 'books/v1/volumes',
      query: 'q=' + searchString+'&maxResults=40');
  Map<String, dynamic> result = json.decode(await http.read(uri));
  var items = result['items'];
  List<Card> cards = [];
  for (var i = 0; i < items.length; i++) {
    cards.add(createCard(items[i]));
  }
  return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return cards[index];
      });
}

Card createCard(item) {
  Book book = Book(item);
  return BookCard(book);
}

@override
State<StatefulWidget> createState() {
  // TODO: implement createState
  throw UnimplementedError();
}
