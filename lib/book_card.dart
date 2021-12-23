import 'package:flutter/material.dart';
import 'package:google_books/book.dart';
import 'package:url_launcher/url_launcher.dart';

class BookCard extends Card {
  BookCard(this.book, {Key? key})
      : super(
            key: key,
            elevation: 5,
            margin: const EdgeInsets.all(10.0),
            child: getContent(book));

  final Book book;
}

Future<void> launchInBrowser(String url) async {
  if (!await launch(
    url,
    forceWebView: false,
  )) {
    throw 'Could not launch $url';
  }
}

Widget getContent(Book book) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    book.authors,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    book.publisher,
                  ),
                  Text(
                    book.publishedDate,
                  ),
                  Text(
                    book.pageCount.toString() + ' pages',
                  ),
                  Text(
                    book.isbns,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image(
                    image: NetworkImage(book.thumbnail),
                    alignment: Alignment.center,
                  ),
                  Text(
                    book.price,
                  ),
                  InkWell(
                    child: Text(
                      book.buyLink == '' ? '' : 'Buy',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () => launchInBrowser(
                      book.buyLink,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                book.description,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
