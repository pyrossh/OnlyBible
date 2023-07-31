import "dart:io";
import 'package:kannada_bible_app/domain/book.dart';

void main() {
  final lines = File("./scripts/bibles/kannada.csv").readAsLinesSync();
  final List<Book> books = [];
  lines.map((line) => line.split("|")).forEach((item) {
    var book = int.parse(item[0]);
    var chapter = int.parse(item[1]);
    var verse = item[3];
    double start = 0;
    double end = 0;
    if (item.length > 4) {
      start = double.parse(item[4]);
      end = double.parse(item[5]);
    }
    if (books.length-1 < book) {
      books.add(Book(name: allBooks[book], localeName: allBooks[book], chapters: []));
    }
    if (books[book].chapters.length < chapter) {
      books[book].chapters.add(Chapter(verses: []));
    }
    books[book].chapters[chapter-1].verses.add(Verse(
        text: verse,
        audioRange: TimeRange(start: start, end: end),
    ));
  });
  var sb = StringBuffer();
  sb.writeln('import "book.dart";\n');
  sb.writeln('final List<Book> kannadaBible = [');
  books.forEach((b) {
    sb.writeln('  Book(name: "${b.name}", localeName: "${b.localeName}", chapters: [');
    b.chapters.forEach((c) {
      sb.writeln('    Chapter(verses: [');
      c.verses.forEach((v) {
        sb.writeln('      Verse(text: "${v.text}", audioRange: TimeRange(start: ${v.audioRange.start}, end: ${v.audioRange.end})),');
      });
      sb.writeln(']),');
    });
    sb.writeln(']),');
  });
  sb.writeln('];');
  File("./lib/domain/kannada_gen.dart").writeAsStringSync(sb.toString());
}
