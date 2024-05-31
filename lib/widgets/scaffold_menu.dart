import "package:flutter/material.dart";
import "package:only_bible_app/utils.dart";

class ScaffoldMenu extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const ScaffoldMenu({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      body: SafeArea(
        child: ColoredBox(
          color: Colors.black.withOpacity(0.7),
          child: ColoredBox(
            color: backgroundColor ?? context.theme.colorScheme.background,
            child: child,
          ),
        ),
      ),
    );
  }
}
