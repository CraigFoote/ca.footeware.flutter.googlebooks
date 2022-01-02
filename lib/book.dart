class Book {
  late Map<String, dynamic> volumeInfo;
  Map<String, dynamic> parsedJson;

  Book(this.parsedJson) {
    volumeInfo = parsedJson['volumeInfo'];
  }

  String get title {
    try {
      return volumeInfo['title'];
    } catch (e) {
      return 'Unknown Title';
    }
  }

  String get authors {
    try {
      return volumeInfo['authors'].join(', ');
    } catch (e) {
      return 'Unknown Author(s)';
    }
  }

  String get publisher {
    try {
      return volumeInfo['publisher'];
    } catch (e) {
      return 'Unknown Publisher';
    }
  }

  String get publishedDate {
    try {
      return volumeInfo['publishedDate'];
    } catch (e) {
      return 'Unknown Publish Date';
    }
  }

  String get pageCount {
    try {
      return volumeInfo['pageCount'].toString();
    } catch (e) {
      return 'Unknown ';
    }
  }

  String get description {
    try {
      return volumeInfo['description'];
    } catch (e) {
      return 'Unknown description';
    }
  }

  String get thumbnail {
    try {
      var imageLinks = volumeInfo['imageLinks'];
      return imageLinks['thumbnail'];
    } catch (e) {
      return 'Thumbnail not found';
    }
  }

  String get isbns {
    try {
      var industryIdentifiers = volumeInfo['industryIdentifiers'];
      String concat = '';
      for (var i = 0; i < industryIdentifiers.length; i++) {
        var entry = industryIdentifiers[i];
        var type = entry['type'];
        var identifier = entry['identifier'];
        concat += type! + ': ' + identifier! + '\n';
      }
      return concat;
    } catch (e) {
      return 'ISBN not found';
    }
  }

  String get price {
    try {
      var saleInfo = parsedJson['saleInfo'];
      var retailPrice = saleInfo['retailPrice'];
      var amount = retailPrice['amount'];
      var currencyCode = retailPrice['currencyCode'];
      return '\$' + amount.toString() + currencyCode;
    } catch (e) {
      return 'Unknown Price';
    }
  }

  String get buyLink {
    try {
      var saleInfo = parsedJson['saleInfo'];
      return saleInfo['buyLink'];
    } catch (e) {
      return '';
    }
  }
}
