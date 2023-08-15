import "package:flutter/material.dart";

class HighlightButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const HighlightButton({super.key, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: const SizedBox(width: 45, height: 45),
      ),
    );
  }
}
