import "package:flutter/material.dart";

class HighlightButton extends StatelessWidget {
  final int index;
  final Color color;
  final Function(int) onHighlightSelected;

  const HighlightButton({super.key, required this.index, required this.color, required this.onHighlightSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onHighlightSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(1),
          shape: BoxShape.circle,
        ),
        child: const SizedBox(width: 45, height: 45),
      ),
    );
  }
}
