import "dart:io";
import 'package:only_bible_app/utils.dart';

void main() async {
  print("starting");
  final bibleTxt = await File("./assets/bibles/KJV.txt").readAsString();
  final books = getBibleFromText(bibleTxt);
  for (var book in books) {
    for (var (chapterIndex, chapter) in book.chapters.indexed) {
      // final outputFile = File(outputFilename).openWrite();
    }
  }
  print("finished");
}
