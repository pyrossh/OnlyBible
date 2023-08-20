import "package:flutter/material.dart";

class ModalButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const ModalButton({super.key, required this.onPressed, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 100,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24, color: theme.colorScheme.primary),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
        style: TextButton.styleFrom(
          enableFeedback: true,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: theme.colorScheme.primary,
              width: 1,
            ),
          ),
          shadowColor: theme.shadowColor,
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
