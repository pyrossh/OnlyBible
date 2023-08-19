import "package:flutter/material.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/state.dart";

class NoteSheet extends StatelessWidget {
  final Verse verse;

  const NoteSheet({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    final app = AppModel.of(context);
    return Container(
      padding: EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
        // this will prevent the soft keyboard from covering the text fields
        bottom: MediaQuery.of(context).viewInsets.bottom + 120,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            height: 5 * 24.0,
            child: TextField(
              controller: app.noteTextController,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(filled: true, hintText: "Add a note"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (app.noteTextController.value.text != "")
                ElevatedButton(
                  onPressed: () {
                    app.deleteNote(context, verse);
                  },
                  child: const Text("Delete"),
                ),
              ElevatedButton(
                onPressed: () {
                  app.saveNote(context, verse);
                },
                child: const Text("Save"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
