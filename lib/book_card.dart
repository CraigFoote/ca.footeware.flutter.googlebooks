import 'package:flutter/material.dart';
import 'package:google_books/book.dart';
import 'package:url_launcher/url_launcher.dart';

class BookCard extends Card {
  BookCard(Book book, {Key? key})
      : super(
            key: key,
            elevation: 15,
            margin: const EdgeInsets.all(10),
            child: getContent(book));
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
    padding: const EdgeInsets.all(20),
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
                  SelectableText(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    book.authors,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    book.publisher,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    book.publishedDate,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    book.pageCount.toString() + ' pages',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SelectableText(
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
                  if (book.thumbnail == 'Thumbnail not found')
                    Text(
                      book.thumbnail,
                    ),
                  if (book.thumbnail != 'Thumbnail not found')
                    Image(
                      image: NetworkImage(
                        book.thumbnail,
                      ),
                      alignment: Alignment.center,
                    ),
                  SelectableText(
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
              child: SelectableText(
                book.description,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
