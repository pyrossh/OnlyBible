import 'package:flutter/material.dart';

class TextUtils {
  static error(String msg) {
    return Text(
      style: const TextStyle(
        color: Colors.red,
      ),
      msg,
    );
  }
}