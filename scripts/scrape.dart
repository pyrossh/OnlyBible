import 'dart:convert';
import "dart:io";
import 'package:html/parser.dart';
import 'package:only_bible_app/utils.dart';

final recognisedClasses = ["place", "person", "word"];

Future<List<String>> fetchPage(String bibleName, int bookIndex, int chapterIndex) async {
  final wordbookNo = bookIndex.toString().padLeft(2, "0");
  final wordChapterNo = chapterIndex.toString().padLeft(3, "0");
  print("getting book: $wordbookNo chapter: $chapterIndex");
  var bytes = await File("./scripts/bibles/${bibleName}_new/$wordbookNo/$chapterIndex.htm").readAsBytes();
  var document = parse(utf8.decode(bytes, allowMalformed: true));
  List<String> lines = [];
  var verseIndex = 0;
  var line = "";
  var body = document.getElementById('textBody')!.children;
  for (var node in document.getElementById('textBody')!.children[2].nodes) {
    if (node.attributes["class"] == "verse") {
      // print(node.attributes);
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
  const bibleName = "in";
  const outputFilename = "./assets/bibles/$bibleName.csv";
  if (File(outputFilename).existsSync()) {
    File(outputFilename).deleteSync();
  }
  final outputFile = File(outputFilename).openWrite();
  final bibleTxt = await File("./assets/bibles/kj.csv").readAsString();
  final books = getBibleFromText(bibleTxt);
  final List<String> mismatches = [];
  for (var book in books) {
    for (var (chapterIndex, chapter) in book.chapters.indexed) {
      // .where((it) => book.index == 16 && it.$1 == 7) todo check ethiopia
      // .where((it) => book.index == 39 && it.$1 == 7) todo check clean
      var lines = await fetchPage(bibleName, book.index + 1, chapterIndex + 1);
      if (lines.length != chapter.verses.length) {
        mismatches.add(
            "Mismatched ${book.index + 1} ${chapterIndex + 1} expected: ${lines.length} actual: ${chapter.verses.length}");
      }
      for (var (lindex, line) in lines.indexed) {
        if (line == "") {
          throw Exception("Line empty");
        }
        // dont write last newline
        if (chapterIndex == books.length - 1 && lindex == book.chapters.length - 1) {
          outputFile.write(line);
        } else {
          outputFile.writeln(line);
        }
      }
    }
  }
  await outputFile.flush();
  await outputFile.close();
  print(mismatches.join("\n"));
  print("finished");
}
