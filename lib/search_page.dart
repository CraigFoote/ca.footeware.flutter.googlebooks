import 'package:flutter/material.dart';
import 'package:google_books/search_results_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_theme.dart';

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
  void initState() {
    super.initState();
    _loadPrefs();
  }

  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      switchValue = (prefs.getBool('switchValue') ?? false);
      widget.themeCallback(
          switchValue ? CustomTheme.darkTheme : CustomTheme.lightTheme);
    });
  }

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
                    return SearchResultsPage(searchController.text, '0');
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
                    onChanged: (value) async {
                      final prefs = await SharedPreferences.getInstance();
                      setState(() {
                        switchValue = value;
                        prefs.setBool('switchValue', switchValue);
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
