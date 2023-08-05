import 'dart:convert'; // Contains the JSON encoder
import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object

void main() async {
  var client = Client();
  Response response = await client.get(Uri.parse('https://www.wordproject.org/bibles/kn/02/2.htm'));
  var document = parse(utf8.decode(response.bodyBytes));
  for (var (index, node) in document.getElementById('textBody')!.children[2].nodes.indexed) {
    print(index);
    print(node);
  }
}