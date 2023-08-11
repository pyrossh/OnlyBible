import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/models.dart";

class BibleSelector extends StatelessWidget {
  const BibleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text("Bibles", style: Theme.of(context).textTheme.headlineMedium),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 4,
            children: List.of(
              bibles.map((bible) {
                return Container(
                  margin: const EdgeInsets.only(right: 16, bottom: 16),
                  child: TextButton(
                    child: Text(bible.name),
                    onPressed: () => changeBible(context, bible.id),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
