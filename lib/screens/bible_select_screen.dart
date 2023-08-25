import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:only_bible_app/providers/app_model.dart";
import "package:only_bible_app/widgets/scaffold_menu.dart";
import "package:only_bible_app/widgets/sliver_heading.dart";
import "package:only_bible_app/widgets/sliver_tile_grid.dart";

class BibleSelectScreen extends StatelessWidget {
  const BibleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = AppModel.of(context);
    return ScaffoldMenu(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverHeading(title: "Bibles", showClose: true),
          SliverTileGrid(
            listType: ListType.large,
            children: List.of(
              AppLocalizations.supportedLocales.map((l) {
                return Localizations.override(
                  context: context,
                  locale: Locale(l.languageCode),
                  child: Builder(
                    builder: (context) {
                      final bibleName = AppLocalizations.of(context)!.languageTitle;
                      return TextButton(
                        child: Text(bibleName),
                        // child: Column(
                        //   children: [
                        //     Text(l.name),
                        //     // Text("(${l.localName})"),
                        //   ],
                        // ),
                        onPressed: () {
                          AppModel.ofEvent(context).updateCurrentBible(context, l, bibleName);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
