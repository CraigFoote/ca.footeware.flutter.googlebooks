class Book {
  late String title;
  late String authors;
  late String publisher;
  late String publishedDate;
  late dynamic pageCount;
  late String description;
  late String thumbnail;
  late dynamic isbns;
  late String price;
  late dynamic buyLink;

  Book(Map<String, dynamic> parsedJson) {
    Map<String, dynamic> volumeInfo = parsedJson['volumeInfo'];
    try {
      title = volumeInfo['title'];
    } catch (e) {
      title = 'Unknown Title';
    }
    try {
      authors = volumeInfo['authors'].join(', ');
    } catch (e) {
      authors = 'Unknown Author(s)';
    }
    try {
      publisher = volumeInfo['publisher'];
    } catch (e) {
      publisher = 'Unknown Publisher';
    }
    try {
      publishedDate = volumeInfo['publishedDate'];
    } catch (e) {
      publishedDate = 'Unknown Publish Date';
    }
    try {
      pageCount = volumeInfo['pageCount'];
    } catch (e) {
      pageCount = 'Unknown ';
    }
    try {
      description = volumeInfo['description'];
    } catch (e) {
      description = 'Unknown description';
    }
    try {
      var imageLinks = volumeInfo['imageLinks'];
      thumbnail = imageLinks['thumbnail'];
    } catch (e) {
      thumbnail = 'Thumbnail not found';
    }
    try {
      var industryIdentifiers = volumeInfo['industryIdentifiers'];
      for (var i = 0; i < industryIdentifiers.length; i++) {
        var entry = industryIdentifiers[i];
        var type = entry['type'];
        var identifier = entry['identifier'];
        isbns += type! + ': ' + identifier! + '\n';
      }
    } catch (e) {
      isbns = 'ISBN not found';
    }
    try {
      var saleInfo = parsedJson['saleInfo'];
      var retailPrice = saleInfo['retailPrice'];
      var amount = retailPrice['amount'];
      var currencyCode = retailPrice['currencyCode'];
      price = '\$' + amount.toString() + currencyCode;
    } catch (e) {
      price = 'Unknown Price';
    }
    try {
      var saleInfo = parsedJson['saleInfo'];
      buyLink = saleInfo['buyLink'];
    } catch (e) {
      buyLink = null;
    }
  }
}
