import "package:flutter/material.dart";
import "package:only_bible_app/actions.dart";
import "package:only_bible_app/atom.dart";
import "package:only_bible_app/state.dart";
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
          SliverHeading(title: context.l.bibleSelectTitle, showClose: !firstOpen.value),
          SliverTileGrid(
            listType: ListType.extraLarge,
            children: List.of(
              context.supportedLocalizations.map((l) {
                return TextButton(
                  child: (l.localeLanguageTitle != l.languageTitle)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l.localeLanguageTitle, textScaleFactor: 1.3),
                            Text("(${l.languageTitle})", textScaleFactor: 0.8),
                          ],
                        )
                      : Text(l.languageTitle, textScaleFactor: 1.1),
                  onPressed: () {
                    if (firstOpen.value) {
                      dispatch(const FirstOpenDone());
                    }
                    updateCurrentBible(context, l.localeName, l.languageTitle);
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
