import "package:flutter/material.dart";

class HighlightButton extends StatelessWidget {
  final Color color;
  final Function(Color c) onColorSelected;

  const HighlightButton({super.key, required this.color, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onColorSelected(color),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(1),
          shape: BoxShape.circle,
        ),
        child: const SizedBox(width: 30, height: 30),
      ),
    );
  }
}
