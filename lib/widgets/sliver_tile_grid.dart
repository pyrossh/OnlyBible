import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";

enum ListType { small, large }

class SliverTileGrid extends StatelessWidget {
  final ListType listType;
  final List<Widget> children;

  const SliverTileGrid({super.key, this.listType = ListType.small, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDesktop = isWide(context);
    final spacing = isDesktop ? 16.0 : 12.0;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid.count(
        crossAxisCount: listType == ListType.large
            ? 2
            : isDesktop
                ? 6
                : 5,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: listType == ListType.large
            ? 4
            : isDesktop
                ? 1.6
                : 1.5,
        children: children,
      ),
    );
  }
}
