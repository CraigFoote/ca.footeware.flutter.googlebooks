import 'package:flutter/material.dart';
import 'package:google_books/search_results_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_theme.dart';
import 'info_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage(this.title, this.themeCallback, {Key? key})
      : super(key: key);
  final String title;
  final Function(ThemeData) themeCallback;

  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  bool _switchValue = false;
  final _searchController = TextEditingController();
  bool _isDarkTheme = CustomTheme.currentTheme == CustomTheme.darkTheme;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  double get screenWidth {
    return MediaQuery.of(context).size.width;
  }

  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _switchValue = (prefs.getBool('switchValue') ?? false);
      widget.themeCallback(
          _switchValue ? CustomTheme.darkTheme : CustomTheme.lightTheme);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Preferences',
            );
          },
        ),
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
            ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('Search'),
                onPressed: () =>
                    _sendToResults(_searchController.text, 0, screenWidth)),
          ],
        ),
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(
          10.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Dark Theme',
                ),
                Switch(
                  value: _isDarkTheme,
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    setState(
                      () {
                        _isDarkTheme = value;
                        prefs.setBool(
                          'isDarkTheme',
                          _isDarkTheme,
                        );
                        widget.themeCallback(value
                            ? CustomTheme.darkTheme
                            : CustomTheme.lightTheme);
                      },
                    );
                  },
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const InfoPage(
                        title: 'Info',
                      );
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.info,
              ),
              label: const Text('Info'),
            ),
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
