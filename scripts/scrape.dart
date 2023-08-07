import 'dart:convert';
import "dart:io";
import 'package:html/parser.dart';

class Book {
  final int index;
  final String name;
  final String localeName;
  final List<Chapter> chapters;

  const Book({
    required this.index,
    required this.name,
    required this.localeName,
    required this.chapters,
  });
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

List<Book> getBibleFromText(String text) {
  final List<Book> books = [];
  final items = text.split("\n").map((line) => line.split("|"));
  for (var item in items) {
    var book = int.parse(item[0]);
    var chapter = int.parse(item[1]);
    var verse = item[3];
    double start = 0;
    double end = 0;
    if (item.length > 4) {
      start = double.parse(item[4]);
      end = double.parse(item[5]);
    }
    if (books.length - 1 < book) {
      books.add(
        Book(
          index: book,
          name: "",
          localeName: "",
          chapters: [],
        ),
      );
    }
    if (books[book].chapters.length < chapter) {
      // ignore: prefer_const_constructors
      books[book].chapters.add(Chapter(verses: []));
    }
    books[book].chapters[chapter - 1].verses.add(
          Verse(
            text: verse,
            audioRange: TimeRange(start: start, end: end),
          ),
        );
  }
  return books;
}

final recognisedClasses = ["place", "person", "word"];

Future<List<String>> fetchPage(int bookIndex, int chapterIndex) async {
  final wordbookNo = bookIndex.toString().padLeft(2, "0");
  final wordChapterNo = chapterIndex.toString().padLeft(3, "0");
  print("getting book: $wordbookNo chapter: $chapterIndex");
  var bytes = await File("./scripts/bibles/kj_new/$wordbookNo/$chapterIndex.htm").readAsBytes();
  var document = parse(utf8.decode(bytes, allowMalformed: true));
  List<String> lines = [];
  var verseIndex = 0;
  var line = "";
  for (var node in document.getElementById('textBody')!.children[2].nodes) {
    if (node.attributes["class"] == "verse") {
      final newIndex = int.parse(node.attributes["id"]!);
      if (verseIndex != newIndex) {
        if (newIndex != 1) {
          lines.add(line);
        }
        verseIndex = newIndex;
        final verseNo = verseIndex.toString().padLeft(3, "0");
        line = "$wordbookNo|$wordChapterNo|$verseNo|";
      }
    } else if (node.attributes.isNotEmpty && node.attributes.containsKey("class")) {
      if (!recognisedClasses.contains(node.attributes["class"])) {
        throw Exception("Found unknown class ${node.attributes} ${node.text}");
      }
      if (recognisedClasses.contains(node.attributes["class"])) {
        // ex: verse 1 On that day // we don't want to add a leading space
        final text = node.text!.trim();
        // TODO: find if next character is , then remove space
        // ex: GEN 10
        line += "${line.endsWith("|") ? "" : " "}${node.text!.trim()} ";
      }
    }
    if (node.runtimeType.toString() == "Text") {
      if (node.text!.trim().contains("|")) {
        throw Exception("Pipe operator found in ${node.text}");
      }
      line += node.text!.trim().replaceAll("\n", "");
    }
  }
  lines.add(line);
  return lines;
}

void main() async {
  print("starting");
  const outputFilename = "./assets/bibles/kj.csv";
  if (File(outputFilename).existsSync()) {
    File(outputFilename).deleteSync();
  }
  final outputFile = File(outputFilename).openWrite();
  final bibleTxt = await File("./scripts/bibles/kannada.csv").readAsString();
  final books = getBibleFromText(bibleTxt);
  final List<Future<List<String>>> futures = [];
  books.forEach((book) {
    book.chapters.indexed
        // .where((it) => book.index == 16 && it.$1 == 7) todo check ethiopia
        // .where((it) => book.index == 39 && it.$1 == 7) todo check clean
    .forEach((it) {
      futures.add(fetchPage(book.index + 1, it.$1 + 1));
    });
  });
  var chaps = await Future.wait(futures);
  for (var (cindex, chapters) in chaps.indexed) {
    for (var (lindex, line) in chapters.indexed) {
      if (line == "") {
        throw Exception("Line empty");
      }
      // dont write last newline
      if (cindex == chaps.length-1 && lindex == chapters.length-1) {
        outputFile.write(line);
      } else {
        outputFile.writeln(line);
      }
    }
  }
  await outputFile.flush();
  await outputFile.close();
  print("finished");
}
