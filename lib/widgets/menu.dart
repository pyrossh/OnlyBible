import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/screens/bible_select_screen.dart";

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = isWide(context);
    final model = AppModel.of(context);
    final modeIcon = model.darkMode ? Icons.dark_mode : Icons.light_mode;
    final boldColor = model.fontBold ? Theme.of(context).shadowColor : Colors.grey;
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert, size: isDesktop ? 28 : 22),
      offset: Offset(0.0, isDesktop ? 60 : 30),
      onSelected: (int v) {
        if (v == 1) {
          Navigator.of(context).push(
            createNoTransitionPageRoute(
              const BibleSelectScreen(),
            ),
          );
        }
        if (v == 2) {
          model.toggleMode();
        }
        if (v == 3) {
          model.toggleBold();
        }
        if (v == 4) {
          model.increaseFont();
        }
        if (v == 5) {
          model.decreaseFont();
        }
      },
      itemBuilder: (BuildContext itemContext) {
        return [
          if (!isDesktop)
            PopupMenuItem(
              value: 1,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  model.bible.shortName(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          PopupMenuItem(
            value: 2,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Icon(modeIcon, size: 28),
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Icon(Icons.format_bold, size: 28, color: boldColor),
            ),
          ),
          PopupMenuItem(
            value: 4,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: const Icon(Icons.add_circle, size: 28),
            ),
          ),
          PopupMenuItem(
            value: 5,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: const Icon(Icons.remove_circle, size: 28),
            ),
          ),
        ];
      },
    );
  }
}
