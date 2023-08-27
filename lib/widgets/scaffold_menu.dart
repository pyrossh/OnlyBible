import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/utils.dart";

class ScaffoldMenu extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const ScaffoldMenu({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final isWide = context.isWide && !firstOpen.value;
    return Scaffold(
      backgroundColor: isWide ? Colors.transparent : context.theme.colorScheme.background,
      body: SafeArea(
        child: Container(
          color: Colors.black.withOpacity(0.7),
          margin: EdgeInsets.only(left: isWide ? 250 : 0),
          child: Container(
            color: backgroundColor ?? context.theme.colorScheme.background,
            margin: EdgeInsets.only(right: isWide ? pageWidth - 750 : 0),
            child: child,
          ),
        ),
      ),
    );
  }
}
