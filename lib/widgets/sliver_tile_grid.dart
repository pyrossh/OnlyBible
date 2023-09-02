import "package:flutter/material.dart";
import "package:only_bible_app/utils.dart";

enum ListType {
  small,
  large,
  extraLarge;

  int crossAxisCount() {
    switch (this) {
      case ListType.small:
        return 5;
      case ListType.large:
        return 2;
      case ListType.extraLarge:
        return 2;
    }
  }

  double childAspectRatio(bool isDesktop) {
    switch (this) {
      case ListType.small:
        return isDesktop ? 1.8 : 1.4;
      case ListType.large:
        return isDesktop ? 5 : 4;
      case ListType.extraLarge:
        return isDesktop ? 3 : 2.8;
    }
  }
}

class SliverTileGrid extends StatelessWidget {
  final ListType listType;
  final List<Widget> children;

  const SliverTileGrid({super.key, this.listType = ListType.small, required this.children});

  @override
  Widget build(BuildContext context) {
    final spacing = context.isWide ? 16.0 : 12.0;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid.count(
        crossAxisCount: listType.crossAxisCount(),
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: listType.childAspectRatio(context.isWide),
        children: children,
      ),
    );
  }
}
