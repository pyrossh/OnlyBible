import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_swipe_detector/flutter_swipe_detector.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/navigation.dart";
import "package:only_bible_app/store/state.dart";
import "package:only_bible_app/widgets/highlight_button.dart";
import "package:share_plus/share_plus.dart";
import "../theme.dart";

class Menu extends StatelessWidget {
  final Offset anchor;

  const Menu({super.key, required this.anchor});

  @override
  Widget build(BuildContext context) {
    final iconColor = darkModeAtom.value ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9);
    final audioIcon = isPlaying.watch(context) ? Icons.pause_circle_outline : Icons.play_circle_outline;
    void onHighlight(int index) {
      setHighlight(context, index);
    }

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            left: anchor.dx,
            top: anchor.dy,
            child: FractionalTranslation(
              translation: const Offset(-0.25, -1.25),
              child: Material(
                // shape: const Recta(),
                elevation: 5,
                clipBehavior: Clip.hardEdge,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => removeHighlight(context),
                            icon: Icon(Icons.cancel_outlined, size: 28, color: iconColor),
                          ),
                          HighlightButton(
                            index: 0,
                            color: darkModeAtom.value ? darkHighlights[0] : lightHighlights[0],
                            onHighlightSelected: onHighlight,
                          ),
                          HighlightButton(
                            index: 1,
                            color: darkModeAtom.value ? darkHighlights[1] : lightHighlights[1],
                            onHighlightSelected: onHighlight,
                          ),
                          HighlightButton(
                            index: 2,
                            color: darkModeAtom.value ? darkHighlights[2] : lightHighlights[2],
                            onHighlightSelected: onHighlight,
                          ),
                          HighlightButton(
                            index: 3,
                            color: darkModeAtom.value ? darkHighlights[3] : lightHighlights[3],
                            onHighlightSelected: onHighlight,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => {},
                            icon: Icon(Icons.border_color_outlined, size: 28, color: iconColor),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => {},
                            icon: Icon(Icons.copy, size: 28, color: iconColor),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: Icon(audioIcon, size: 28, color: iconColor),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => {},
                            icon: Icon(Icons.post_add_outlined, size: 28, color: iconColor),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => {},
                            icon: Icon(Icons.share_outlined, size: 28, color: iconColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
