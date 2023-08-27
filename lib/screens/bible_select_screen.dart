import "package:flutter/material.dart";
import "package:only_bible_app/providers/app_provider.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/scaffold_menu.dart";
import "package:only_bible_app/widgets/sliver_heading.dart";
import "package:only_bible_app/widgets/sliver_tile_grid.dart";

class BibleSelectScreen extends StatelessWidget {
  const BibleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMenu(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverHeading(title: context.l.bibleSelectTitle, showClose: !context.app.firstOpen),
          SliverTileGrid(
            listType: ListType.large,
            children: List.of(
              context.supportedLocalizations.map((l) {
                return TextButton(
                  child: Text(l.languageTitle),
                  // child: Column(
                  //   children: [
                  //     Text(l.name),
                  //     // Text("(${l.localName})"),
                  //   ],
                  // ),
                  onPressed: () {
                    AppProvider.ofEvent(context).updateCurrentBible(context, Locale(l.localeName), l.languageTitle);
                    if (context.appEvent.firstOpen) {
                      context.appEvent.updateFirstOpen();
                      context.appEvent.pushBookChapter(context, 0, 0, null);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
