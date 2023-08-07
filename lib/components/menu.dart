import 'package:flutter/material.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:only_bible_app/state.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final moreIcon = isWide(context) ? Icons.more_vert : Icons.more_vert;
    const spacing = 25.0;
    return PopupMenuButton(
      constraints: const BoxConstraints.tightFor(width: 80),
      icon: Icon(moreIcon, size: 28),
      offset: const Offset(0.0, 60),
      itemBuilder: (BuildContext itemContext) {
        return [
          PopupMenuItem(
            value: 1,
            child: StatefulBuilder(
              builder: (BuildContext menuContext, StateSetter setState) {
                final modeIcon = darkMode.reactiveValue(menuContext) ? Icons.dark_mode : Icons.light_mode;
                final boldColor = fontBold.reactiveValue(menuContext) ? Colors.red : Colors.grey;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(modeIcon, size: 28),
                      onPressed: toggleMode,
                    ),
                    Container(margin: const EdgeInsets.only(top: spacing)),
                    // TODO: figure out bold active/inactive color
                    const IconButton(
                      icon: Icon(Icons.format_bold, size: 28),
                      onPressed: toggleBold,
                    ),
                    Container(margin: const EdgeInsets.only(top: spacing)),
                    const IconButton(
                      icon: Icon(Icons.add_circle, size: 28),
                      onPressed: increaseFont,
                    ),
                    Container(margin: const EdgeInsets.only(top: spacing)),
                    const IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        size: 28,
                      ),
                      onPressed: decreaseFont,
                    ),
                  ],
                );
              },
            ),
          ),
        ];
      },
    );
  }
}
