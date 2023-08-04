import 'package:flutter/material.dart';

import '../state.dart';

class Tile extends StatelessWidget {
  final String name;

  const Tile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWide(context) ? 60 : 50,
      height: isWide(context) ? 60 : 40,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFEAE9E9),
      ),
      child: Center(
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "SanFrancisco",
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9A1111),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
