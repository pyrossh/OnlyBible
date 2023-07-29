import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const highlightColor = Color(0xAAF8D0DC);

class VerseNo extends StatelessWidget {
  final int index;

  const VerseNo({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 2),
      child: Text(
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Color(0xFF9A1111),
        ),
        "${index + 1}",
      ),
    );
  }
}

class Verse extends HookWidget {
  final int index;
  final String text;

  const Verse({super.key, required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    var selected = useState(false);
    onTap() => selected.value = !selected.value;
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: selected.value ? highlightColor : Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  child: VerseNo(index: index),
                ),
                Flexible(
                  child: Text(
                    style: const TextStyle(
                      color: Color(0xFF010101),
                      fontSize: 16,
                      // fontFamily: "SanFranciscoPro",
                      fontWeight: FontWeight.w500,
                      // letterSpacing: 0.5,
                    ),
                    text,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}