import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:only_bible_app/providers/app_model.dart";
import "package:only_bible_app/widgets/scaffold_menu.dart";
import "package:only_bible_app/widgets/sliver_heading.dart";
import "package:only_bible_app/widgets/sliver_tile_grid.dart";

class LocaleSelectScreen extends StatelessWidget {
  const LocaleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMenu(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverHeading(title: "Choose your preferred language", showClose: true),
          SliverTileGrid(
            listType: ListType.large,
            children: List.of(
              AppLocalizations.supportedLocales.map((l) {
                return Localizations.override(
                  context: context,
                  locale: Locale(l.languageCode),
                  child: Builder(
                    builder: (context) {
                      return TextButton(
                        child: Text(AppLocalizations.of(context)!.languageTitle),
                        // child: Column(
                        //   children: [
                        //     Text(l.name),
                        //     // Text("(${l.localName})"),
                        //   ],
                        // ),
                        onPressed: () {
                          AppModel.ofEvent(context).updateCurrentLocale(l);
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
