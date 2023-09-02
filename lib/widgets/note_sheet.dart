import "package:flutter/material.dart";
import "package:only_bible_app/models.dart";
import 'package:only_bible_app/store/state.dart';
import "package:only_bible_app/widgets/modal_button.dart";

class NoteSheet extends StatelessWidget {
  final Bible bible;
  final Verse verse;

  const NoteSheet({super.key, required this.verse, required this.bible});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 15),
            child: Text(
              "Note on ${bible.books[verse.book].name(context)} ${verse.chapter + 1}:${verse.index + 1}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            height: 8 * 24.0,
            child: TextField(
              controller: noteTextController,
              maxLines: 100,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(filled: true, hintText: "Add a note"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (noteTextController.value.text != "")
                  ModalButton(
                    onPressed: () => deleteNote(context, verse),
                    icon: Icons.delete_outline,
                    label: "Delete",
                  ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ModalButton(
                        onPressed: () {
                          saveNote(context, verse);
                        },
                        icon: Icons.save_outlined,
                        label: "Save",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
