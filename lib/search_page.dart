import 'package:flutter/material.dart';
import 'package:google_books/search_results_page.dart';
import 'info_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage(this.title, {Key? key})
      : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

  double get screenWidth {
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InfoPage(title: 'Info'),
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
            tooltip: 'Info',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: screenWidth * .7,
                child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    maxLength: 50,
                    enableSuggestions: true,
                    onSubmitted: (value) =>
                        _sendToResults(value, 0, screenWidth))),
            ],
        ),
      ),
    );
  }

  _sendToResults(String text, int i, double screenWidth) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return SearchResultsPage(_searchController.text, 0, screenWidth);
      }),
    );
  }
}
