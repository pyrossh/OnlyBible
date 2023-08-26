import "package:flutter/material.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/providers/app_model.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/modal_button.dart";

class NoteSheet extends StatelessWidget {
  final Verse verse;

  const NoteSheet({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    final app = AppModel.of(context);
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
              "Note on ${app.bible.books[verse.book].name(context)} ${verse.chapter + 1}:${verse.index + 1}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            height: 8 * 24.0,
            child: TextField(
              controller: app.noteTextController,
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
                if (app.noteTextController.value.text != "")
                  ModalButton(
                    onPressed: () => app.deleteNote(context, verse),
                    icon: Icons.delete_outline,
                    label: "Delete",
                  ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ModalButton(
                        onPressed: () {
                          context.appEvent.saveNote(context, verse);
                          // context.chapterEvent.clearSelections();
                          // context.appEvent.hideActions(context);
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
