import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class Utils {
  static Future<String> loadAsset(BuildContext context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/kannada.csv');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
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