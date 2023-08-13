import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";

class VerseText extends StatelessWidget {
  final int index;
  final String text;

  const VerseText({super.key, required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    final model = AppModel.of(context);
    final selected = ChapterViewModel.of(context).isVerseSelected(index);
    final bodySize = Theme.of(context).textTheme.bodyMedium!.fontSize! + model.fontSizeDelta;
    final weight = model.fontBold ? FontWeight.w600 : Theme.of(context).textTheme.bodyMedium!.fontWeight;

    return GestureDetector(
      onTap: () {
        ChapterViewModel.ofEvent(context).onVerseSelected(context, index);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).highlightColor : Theme.of(context).colorScheme.background,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 4),
              child: Transform.translate(
                offset: const Offset(0, 2),
                child: Text("${index + 1}", style: Theme.of(context).textTheme.labelMedium),
              ),
            ),
            Flexible(
              child: Text(
                text,
                style: TextStyle(fontSize: bodySize, fontWeight: weight),
              ),
            )
          ],
        ),
      ),
    );
  }
}
