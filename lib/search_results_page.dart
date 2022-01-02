import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_books/book_card.dart';
import 'package:http/io_client.dart';

import 'apikey.dart';
import 'book.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage(this._searchString, this._pageNumber, {Key? key})
      : super(key: key);
  final String _searchString;
  final num _pageNumber;

  @override
  State<StatefulWidget> createState() => SearchResultsPageState();
}

class SearchResultsPageState extends State<SearchResultsPage> {
  late List<Book> _books;
  late bool _haveBooks;
  late num _numResults;

  @override
  void initState() {
    super.initState();
    _haveBooks = false;
    _books = [];
    _getSearchResults();
  }

  void _getSearchResults() async {
    Uri url = Uri(
        scheme: 'https',
        host: 'www.googleapis.com',
        path: 'books/v1/volumes',
        query: 'q=' +
            widget._searchString +
            '&maxResults=10&startIndex=' +
            widget._pageNumber.toString() +
            '&key=' +
            apikey);
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(client);
    await http.get(url).then(
      (response) async {
        if (response.statusCode == 200) {
          Map<String, dynamic> result = json.decode(response.body);
          var items = result['items'];
          for (var i = 0; i < items.length; i++) {
            var item = items[i];
            Book book = Book(item);
            _books.add(book);
          }
          _numResults = result['totalItems'];
          setState(() => _haveBooks = true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        title: Text(
            "Google Books - Search Results for '" + widget._searchString + "'"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: !_haveBooks
            ? Container()
            : ListView.builder(
                itemCount: _books.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Text(
                      '$_numResults Results',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20.0,
                      ),
                    );
                  } else if (index == _books.length) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchResultsPage(
                                    widget._searchString,
                                    widget._pageNumber + 10),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_right),
                            label: const Text(
                              'Next',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  Card bookCard = BookCard(_books[index]);
                  return bookCard;
                },
              ),
      ),
    );
  }
}
