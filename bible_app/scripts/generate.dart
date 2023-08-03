import "dart:io";
import 'package:only_bible_app/models/book.dart';
import 'package:only_bible_app/state.dart';

void main() async {
  final bibleTxt = await File("./scripts/bibles/kannada.csv").readAsString();
  final books = getBibleFromText(bibleTxt);
  // File("./lib/domain/kannada_gen.dart").writeAsStringSync(sb.toString());
}
