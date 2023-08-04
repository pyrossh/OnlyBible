import 'package:flutter/material.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:only_bible_app/state.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final moreIcon = isWide(context) ? Icons.more_vert : Icons.more_vert;
    return PopupMenuButton(
      icon: Icon(moreIcon, size: 36),
      offset: const Offset(0.0, 70),

      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: isWide(context) ? 10 : 5),
          onTap: toggleMode,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(margin: EdgeInsets.only(left: isWide(context) ? 10 : 25)),
              Icon(darkMode.reactiveValue(context) ? Icons.dark_mode : Icons.light_mode, color: Colors.black, size: 30),
              Text("   ${darkMode.reactiveValue(context) ? "Dark" : "Light"} Mode"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 1,
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.black, size: 30),
                onPressed: increaseFont,
              ),
              Text("      Font      "),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.black, size: 30),
                onPressed: decreaseFont,
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 1,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("About"),
            ],
          ),
        ),
      ],
    );
  }
}
