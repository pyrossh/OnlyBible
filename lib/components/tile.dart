import 'package:flutter/material.dart';
import 'package:only_bible_app/state.dart';

class Tile extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;

  const Tile({super.key, required this.name, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.of(context).size.width - 40; // width - margin
    return Container(
      width: isWide(context) ? 60 : (availableWidth/5).round() - 13,
      height: isWide(context) ? 60 : 40,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      child: TextButton(
        onPressed: onPressed,
        child: Text(name),
      ),
    );
  }
}
