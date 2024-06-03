import 'dart:convert';
import "dart:io";
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:only_bible_app/models.dart';

final booksNames = [
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

class Heading {
  int vIndex;
  String text;

  Heading(this.vIndex, this.text);

  toString() {
    return "vIndex: ${vIndex}" + ", text: " + text;
  }
}

Future<List<Heading>> fetchPage(String book, int chapterIndex) async {
  print("fetching $book $chapterIndex \n");
  final res = await http.get(
    Uri.parse(
      "https://www.biblegateway.com/passage/?search=$book%20$chapterIndex&version=NKJV",
    ),
  );
  var document = parse(utf8.decode(res.bodyBytes, allowMalformed: true));
  var title = document
      .getElementsByClassName("psalm-title")
      .map(
        (it) => it.nodes[0].nodes
            .map(
              (n) => n.attributes["class"] != null &&
                      n.attributes["class"]!.contains("crossreference")
                  ? ""
                  : n.text,
            )
            .join(""),
      )
      .join("");
  var els = document
      .getElementsByTagName("span")
      .where((it) => it.id.contains("en-NKJV"))
      .where((it) => it.parent?.localName == "h3")
      .map(
        (it) =>
            "${it.className.split(" ")[1]} ${it.nodes.map((n) => n.attributes["class"] != null && n.attributes["class"]!.contains("crossreference") ? "" : n.text).join("")}",
      )
      .map((it) {
    final items = it.split(" ");
    final vIndex = int.parse(items[0].split("-").last) - 1;
    final heading = items.sublist(1).join(" ");
    return Heading(vIndex, heading);
  }).toList();
  if (title != "") {
    if (els.isNotEmpty) {
      els.first.text = title + "<br>" + els.first.text;
    } else {
      els.add(Heading(0, title));
    }
  }
  return els;
}

void main() async {
  final engBooks = parseBible(
    "English",
    await File("./assets/bibles/English.txt").readAsString(),
  );
  print("starting");
  const bibleName = "Telugu";
  const outputFilename = "./assets/bibles/${bibleName}2.txt";
  if (File(outputFilename).existsSync()) {
    File(outputFilename).deleteSync();
  }
  final outputFile = File(outputFilename).openWrite();
  final bibleTxt = await File("./assets/bibles/$bibleName.txt").readAsString();
  final books = parseBible(bibleName, bibleTxt);
  for (var (bookIndex, book) in books.indexed) {
    for (var (chapterIndex, chapter) in book.chapters.indexed) {
      for (var (verseIndex, verse) in chapter.verses.indexed) {
        // print("$bookIndex $chapterIndex $verseIndex");
        final engVerses = engBooks[bookIndex].chapters[chapterIndex].verses;
        if (engVerses.length > verseIndex) {
          final engVerseHeading = engVerses[verseIndex].heading;
          if (engVerseHeading != "") {
            verse.heading = engVerseHeading;
          }
        }
        outputFile.writeln(
          "${book.index}|${chapter.index}|${verse.index}|${verse.heading}|${verse.text}",
        );
      }
    }
  }
  await outputFile.flush();
  await outputFile.close();
  print("finished");
}
