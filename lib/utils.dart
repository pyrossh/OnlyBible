import 'package:only_bible_app/models.dart';

List<Book> getBibleFromText(String text) {
  final List<Book> books = [];
  final lines = text.split("\n");
  for (var (index, line) in lines.indexed) {
    // ignore last empty line
    if (lines.length - 1 == index) {
      continue;
    }
    var book = int.parse(line.substring(0, 2));
    var chapter = int.parse(line.substring(3, 6));
    // var verseNo = line.substring(7, 10);
    var verseText = line.substring(11);
    double start = 0;
    double end = 0;
    // if (item.length > 4) {
    //   start = double.parse(item[4]);
    //   end = double.parse(item[5]);
    // }
    if (books.length < book) {
      books.add(
        Book(
          index: book - 1,
          name: bookNames[book-1],
          chapters: [],
        ),
      );
    }
    if (books[book - 1].chapters.length < chapter) {
      // ignore: prefer_const_constructors
      books[book - 1].chapters.add(Chapter(verses: []));
    }
    books[book - 1].chapters[chapter - 1].verses.add(
          Verse(
            text: verseText,
            audioRange: TimeRange(start: start, end: end),
          ),
        );
  }
  return books;
}
