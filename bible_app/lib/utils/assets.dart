import "dart:convert";
import "dart:io";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";

class Utils {
  static Future<String> loadGzAsset(BuildContext context, String file) async {
    final bytes = await DefaultAssetBundle.of(context).load("assets/$file");
    return utf8.decode(GZipCodec().decode(bytes.buffer.asUint8List()));
  }

  static Future<String> loadAsset(BuildContext context, String file) async {
    return DefaultAssetBundle.of(context).loadString("assets/$file");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/counter.txt");
  }

  Future<List<String>> readCounter() async {
    try {
      final file = await _localFile;
      final lines = await file
          .openRead(10, 100)
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .toList();
      return lines;
    } catch (e) {
      return [];
    }
  }
}
