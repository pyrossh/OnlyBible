import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";

enum ListType { small, large }

class SliverTileGrid extends StatelessWidget {
  final ListType listType;
  final List<Widget> children;

  const SliverTileGrid({super.key, this.listType = ListType.small, required this.children});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid.count(
        crossAxisCount: listType == ListType.large
            ? 2
            : isWide(context)
                ? 6
                : 5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: listType == ListType.large
            ? 4
            : isWide(context)
                ? 1.6
                : 1.5,
        children: children,
      ),
    );
  }
}
