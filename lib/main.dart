import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_books/custom_theme.dart';
import 'package:http/http.dart' as http;

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
  ThemeData currentTheme = CustomTheme.lightTheme;

  void themeCallback(value) {
    setState(() => CustomTheme.currentTheme = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: CustomTheme.currentTheme,
      debugShowCheckedModeBanner: false,
      home: SearchPage(title, themeCallback),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage(this.title, this.themeCallback, {Key? key})
      : super(key: key);
  final String title;
  final Function(ThemeData) themeCallback;

  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  bool switchValue = false;
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              child: TextField(
                controller: searchController,
                autofocus: true,
                maxLength: 50,
                enableSuggestions: true,
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Search'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SearchResultsPage(searchController.text);
                  }),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Row(
                children: [
                  const Text('Dark Theme'),
                  Switch(
                    value: switchValue,
                    onChanged: (value) {
                      setState(() {
                        switchValue = value;
                        widget.themeCallback(value
                            ? CustomTheme.darkTheme
                            : CustomTheme.lightTheme);
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage(this.searchString, {Key? key}) : super(key: key);
  final String searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Books - Search Results for '" + searchString + "'"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<ListView>(
          future: getSearchResults(searchString),
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

  Future<ListView> getSearchResults(String searchString) async {
    Uri uri = Uri(
        scheme: 'https',
        host: 'www.googleapis.com',
        path: 'books/v1/volumes',
        query: 'q=' + searchString);
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
    Map<String, dynamic> volumeInfo = item['volumeInfo'];
    String title;
    try {
      title = volumeInfo['title'];
    } catch (e) {
      title = 'Unknown Title';
    }
    String authors;
    try {
      authors = volumeInfo['authors'].join(', ');
    } catch (e) {
      authors = 'Unknown Author(s)';
    }
    String publisher;
    try {
      publisher = volumeInfo['publisher'];
    } catch (e) {
      publisher = 'Unknown Publisher';
    }
    String publishedDate;
    try {
      publishedDate = volumeInfo['publishedDate'];
    } catch (e) {
      publishedDate = 'Unknown Publish Date';
    }
    var pageCount;
    try {
      pageCount = volumeInfo['pageCount'];
    } catch (e) {
      pageCount = 'Unknown Page Count';
    }
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  authors,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    publisher,
                  ),
                  Text(
                    publishedDate,
                  ),
                  Text(
                    pageCount.toString() + ' pages',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
