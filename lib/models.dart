import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class Bible {
  final int id;
  final String name;
  final bool hasAudio;
  List<Book> books = [];

  Bible({
    required this.id,
    required this.name,
    required this.hasAudio,
  });

  Bible.withBooks({
    required this.id,
    required this.name,
    required this.hasAudio,
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

  static List<String> getBookNames(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.genesis,
      l.exodus,
      l.leviticus,
      l.numbers,
      l.deuteronomy,
      l.joshua,
      l.judges,
      l.ruth,
      l.firstSamuel,
      l.secondSamuel,
      l.firstKings,
      l.secondKings,
      l.firstChronicles,
      l.secondChronicles,
      l.ezra,
      l.nehemiah,
      l.esther,
      l.job,
      l.psalms,
      l.proverbs,
      l.ecclesiastes,
      l.song_of_solomon,
      l.isaiah,
      l.jeremiah,
      l.lamentations,
      l.ezekiel,
      l.daniel,
      l.hosea,
      l.joel,
      l.amos,
      l.obadiah,
      l.jonah,
      l.micah,
      l.nahum,
      l.habakkuk,
      l.zephaniah,
      l.haggai,
      l.zechariah,
      l.malachi,
      l.matthew,
      l.mark,
      l.luke,
      l.john,
      l.acts,
      l.romans,
      l.firstCorinthians,
      l.secondCorinthians,
      l.galatians,
      l.ephesians,
      l.philippians,
      l.colossians,
      l.firstThessalonians,
      l.secondThessalonians,
      l.firstTimothy,
      l.secondTimothy,
      l.titus,
      l.philemon,
      l.hebrews,
      l.james,
      l.firstPeter,
      l.secondPeter,
      l.firstJohn,
      l.secondJohn,
      l.thirdJohn,
      l.jude,
      l.revelation,
    ];
  }
}

class Book {
  final int index;
  final List<Chapter> chapters;

  const Book({
    required this.index,
    required this.chapters,
  });

  String name(BuildContext context) {
    return Bible.getBookNames(context)[index];
  }

  bool isOldTestament() => index < 39;

  bool isNewTestament() => index >= 39;

  String shortName(BuildContext context) {
    final name = this.name(context);
    if (name[0] == "1" || name[0] == "2" || name[0] == "3") {
      return "${name[0]}${name[2].toUpperCase()}${name.substring(3, 5).toLowerCase()}";
    }
    return "${name[0].toUpperCase()}${name.substring(1, 3).toLowerCase()}";
  }
}

class Chapter {
  final List<Verse> verses;

  const Chapter({required this.verses});
}

class Verse {
  final int index;
  final int book;
  final int chapter;
  final String text;

  const Verse({required this.index, required this.text, required this.chapter, required this.book});
}

final bibles = [
  Bible(id: 1, name: "English", hasAudio: false),
  Bible(id: 2, name: "Kannada", hasAudio: true),
  Bible(id: 3, name: "Nepali", hasAudio: false),
  Bible(id: 4, name: "Hindi", hasAudio: false),
  Bible(id: 5, name: "Gujarati", hasAudio: false),
  Bible(id: 6, name: "Malayalam", hasAudio: false),
  Bible(id: 7, name: "Oriya", hasAudio: false),
  Bible(id: 8, name: "Punjabi", hasAudio: false),
  Bible(id: 9, name: "Tamil", hasAudio: false),
  Bible(id: 10, name: "Telugu", hasAudio: false),
  Bible(id: 11, name: "Bengali", hasAudio: false),
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
    var verseNo = int.parse(line.substring(7, 10));
    var verseText = line.substring(11);
    if (books.length < book) {
      books.add(
        Book(
          index: book - 1,
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
            index: verseNo - 1,
            text: verseText,
            chapter: chapter - 1,
            book: book - 1,
          ),
        );
  }
  return books;
}
