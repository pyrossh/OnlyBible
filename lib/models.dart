class Bible {
  final int id;
  final String name;
  List<Book> books = [];

  Bible({
    required this.id,
    required this.name,
  });

  Bible.withBooks({
    required this.id,
    required this.name,
    required this.books,
  });

  List<Book> getOldBooks() {
    return books.where((it) => it.isOldTestament()).toList();
  }

  List<Book> getNewBooks() {
    return books.where((it) => it.isNewTestament()).toList();
  }
}

class Book {
  final int index;
  final String name;
  final List<Chapter> chapters;

  const Book({
    required this.index,
    required this.name,
    required this.chapters,
  });

  bool isOldTestament() => index < 39;

  bool isNewTestament() => index >= 39;

  String shortName() {
    if (name[0] == "1" || name[0] == "2" || name[0] == "3") {
      return "${name[0]}${name[2].toUpperCase()}${name.substring(3, 4).toLowerCase()}";
    }
    return "${name[0].toUpperCase()}${name.substring(1, 3).toLowerCase()}";
  }
}

class Chapter {
  final List<Verse> verses;

  const Chapter({required this.verses});
}

class Verse {
  final String text;
  final TimeRange audioRange;

  const Verse({required this.text, required this.audioRange});
}

class TimeRange {
  final double start;
  final double end;

  const TimeRange({required this.start, required this.end});
}

const bookNames = [
  "Genesis",
  "Exodus",
  "Leviticus",
  "Numbers",
  "Deuteronomy",
  "Joshua",
  "Judges",
  "Ruth",
  "1 Samuel",
  "2 Samuel",
  "1 Kings",
  "2 Kings",
  "1 Chronicles",
  "2 Chronicles",
  "Ezra",
  "Nehemiah",
  "Esther",
  "Job",
  "Psalms",
  "Proverbs",
  "Ecclesiastes",
  "Song of Solomon",
  "Isaiah",
  "Jeremiah",
  "Lamentations",
  "Ezekiel",
  "Daniel",
  "Hosea",
  "Joel",
  "Amos",
  "Obadiah",
  "Jonah",
  "Micah",
  "Nahum",
  "Habakkuk",
  "Zephaniah",
  "Haggai",
  "Zechariah",
  "Malachi",
  "Matthew",
  "Mark",
  "Luke",
  "John",
  "Acts",
  "Romans",
  "1 Corinthians",
  "2 Corinthians",
  "Galatians",
  "Ephesians",
  "Philippians",
  "Colossians",
  "1 Thessalonians",
  "2 Thessalonians",
  "1 Timothy",
  "2 Timothy",
  "Titus",
  "Philemon",
  "Hebrews",
  "James",
  "1 Peter",
  "2 Peter",
  "1 John",
  "2 John",
  "3 John",
  "Jude",
  "Revelation"
];

final bibles = [
  Bible(id: 1, name: "KJV"),
  Bible(id: 2, name: "Kannada"),
  Bible(id: 3, name: "Nepali"),
  Bible(id: 4, name: "Hindi"),
  Bible(id: 5, name: "Gujarati"),
  Bible(id: 6, name: "Malayalam"),
  Bible(id: 7, name: "Oriya"),
  Bible(id: 8, name: "Punjabi"),
  Bible(id: 9, name: "Tamil"),
  Bible(id: 10, name: "Telugu"),
  Bible(id: 11, name: "Bengali"),
];

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