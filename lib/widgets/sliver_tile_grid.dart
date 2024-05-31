import "package:flutter/material.dart";

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

  double childAspectRatio() {
    switch (this) {
      case ListType.small:
        return 1.4;
      case ListType.large:
        return  4;
      case ListType.extraLarge:
        return 2.8;
    }
  }
}

class SliverTileGrid extends StatelessWidget {
  final ListType listType;
  final List<Widget> children;

  const SliverTileGrid({super.key, this.listType = ListType.small, required this.children});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid.count(
        crossAxisCount: listType.crossAxisCount(),
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: listType.childAspectRatio(),
        children: children,
      ),
    );
  }
}
