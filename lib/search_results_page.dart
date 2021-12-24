import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'apikey.dart';
import 'book.dart';
import 'book_card.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage(this.searchString, this.pageNumber, {Key? key})
      : super(key: key);
  final String searchString;
  final num pageNumber;

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
          future:
              getSearchResults(widget.searchString, widget.pageNumber, context),
          builder: (BuildContext context, AsyncSnapshot<ListView> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.data == null) {
              return const Text('No search results found.');
            } else {
              return snapshot.data!;
            }
          },
        ),
      ),
    );
  }
}

Future<ListView> getSearchResults(
    String searchString, num pageNumber, BuildContext context) async {
  Uri uri = Uri(
      scheme: 'https',
      host: 'www.googleapis.com',
      path: 'books/v1/volumes',
      query: 'q=' +
          searchString +
          '&maxResults=10&startIndex=$pageNumber&key=' +
          apikey);

  Map<String, dynamic> result = json.decode(await http.read(uri));
  var items = result['items'];
  List<Card> cards = [];
  for (var i = 0; i < items.length; i++) {
    cards.add(createCard(items[i]));
  }
  return ListView.builder(
      itemCount: cards.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return getNumResults(result);
        } else if (index == cards.length) {
          return getNavButtons(searchString, pageNumber, context);
        }
        return cards[index];
      });
}

Text getNumResults(Map<String, dynamic> result) {
  num numResults = result['totalItems'];
  return Text(
    '$numResults Results',
    style: const TextStyle(
      fontWeight: FontWeight.w900,
    ),
  );
}

Row getNavButtons(String searchString, num pageNumber, BuildContext context) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        // onPressed: getNext(searchString, pageNumber, context),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SearchResultsPage(searchString, pageNumber + 10))),
        icon: const Icon(Icons.arrow_right),
        label: const Text(
          'Next',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    ),
  ]);
}

Card createCard(item) {
  Book book = Book(item);
  return BookCard(book);
}
