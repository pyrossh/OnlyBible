import 'package:flutter/material.dart';

import '../state.dart';

class Tile extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;

  const Tile({super.key, required this.name, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWide(context) ? 60 : 55,
      height: isWide(context) ? 60 : 40,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(),
          // elevation: 4,
          // backgroundColor: const Color(0xFFF6F6F6),
          backgroundColor: const Color(0xFFEAE9E9),
          foregroundColor: const Color(0xFF9A1111),
          textStyle: theme.value.tileText,
        ),
        onPressed: onPressed,
        child: Text(name),
      ),
    );
  }
}
