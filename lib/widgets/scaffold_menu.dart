import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";

class ScaffoldMenu extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const ScaffoldMenu({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          color: Colors.black.withOpacity(0.7),
          margin: EdgeInsets.only(left: isWide(context) ? 250 : 0),
          child: Container(
            color: backgroundColor ?? Theme.of(context).colorScheme.background,
            margin: EdgeInsets.only(right: isWide(context) ? 650 : 0),
            child: child,
          ),
        ),
      ),
    );
  }
}
