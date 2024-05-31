class Bible {
  final String name;
  final List<Book> books;

  const Bible({
    required this.name,
    required this.books,
  });

  String shortName() {
    return name.substring(0, 3).toUpperCase();
  }

  List<Book> getOldBooks() {
    return books.where((it) => it.isOldTestament()).toList();
  }

  List<Book> getNewBooks() {
    return books.where((it) => it.isNewTestament()).toList();
  }
}

class Book {
  final int index;
  final List<Chapter> chapters;

  const Book({
    required this.index,
    required this.chapters,
  });

  bool isOldTestament() => index < 39;

  bool isNewTestament() => index >= 39;

  String shortName(String name) {
    if (name[0] == "1" || name[0] == "2" || name[0] == "3") {
      return "${name[0]}${name[2].toUpperCase()}${name.substring(3, 4).toLowerCase()}";
    }
    return "${name[0].toUpperCase()}${name.substring(1, 3).toLowerCase()}";
  }
}

class Chapter {
  final int index;
  final int book;
  final List<Verse> verses;

  const Chapter(
      {required this.index, required this.verses, required this.book});
}

class Verse {
  final int index;
  final String bibleName;
  final int book;
  final int chapter;
  String heading;
  final String text;

  Verse({
    required this.index,
    required this.text,
    required this.bibleName,
    required this.chapter,
    required this.book,
    required this.heading,
  });
}

List<Book> parseBible(String bibleName, String text) {
  final List<Book> books = [];
  final lines = text.split("\n");
  for (var (index, line) in lines.indexed) {
// ignore last empty line
    if (lines.length - 1 == index) {
      continue;
    }
    final arr = line.split("|");
    final book = int.parse(arr[0]);
    final chapter = int.parse(arr[1]);
    final verseNo = int.parse(arr[2]);
    final heading = arr[3];
    final verseText = arr.sublist(4, arr.length).join("|");
    if (books.length < book + 1) {
      books.add(
        Book(
          index: book,
          chapters: [],
        ),
      );
    }
    if (books[book].chapters.length < chapter + 1) {
      books[book].chapters.add(
            Chapter(
              index: chapter,
              book: book,
              verses: [],
            ),
          );
    }
    books[book].chapters[chapter].verses.add(
          Verse(
            index: verseNo,
            bibleName: bibleName,
            chapter: chapter,
            book: book,
            text: verseText,
            heading: heading,
          ),
        );
  }
  return books;
}

class HistoryFrame {
  final int book;
  final int chapter;

  const HistoryFrame({required this.book, required this.chapter});
}
