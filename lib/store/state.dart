import "dart:developer";
import "dart:io";
import "package:atoms_state/atoms_state.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get_storage/get_storage.dart";
import "package:just_audio/just_audio.dart";
import "package:only_bible_app/dialog.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/store/storage.dart";
import "package:only_bible_app/theme.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/navigation.dart";
import "package:only_bible_app/store/actions.dart";
import "package:path_provider/path_provider.dart";

final box = GetStorage("only-bible-app-prefs");
final player = AudioPlayer();
final noteTextController = TextEditingController();
final storage = FileStorage(box: box);

initState() async {
  await box.initStorage;
}

final bibleAtom = AsyncAtom(
  callback: loadBible,
);

final firstOpenAtom = Atom(
  storage: storage,
  key: "firstOpen",
  initialState: true,
  reducer: (state, action) {
    if (action is FirstOpenDone) {
      return false;
    }
    return state;
  },
);

final languageCodeAtom = Atom(
  storage: storage,
  key: "languageCode",
  initialState: "en",
  reducer: (state, action) {
    if (action is UpdateBible) {
      return action.code;
    }
    return state;
  },
);

final bibleNameAtom = Atom(
  storage: storage,
  key: "bibleName",
  initialState: "English",
  reducer: (state, action) {
    if (action is UpdateBible) {
      return action.name;
    }
    return state;
  },
);

final engTitlesAtom = Atom(
  storage: storage,
  key: "engTitles",
  initialState: false,
  reducer: (state, action) {
    if (action is ToggleEngTitles) {
      return !state;
    }
    return state;
  },
);

final boldFontAtom = Atom(
  storage: storage,
  key: "boldFont",
  initialState: false,
  reducer: (state, action) {
    if (action is ToggleBoldFont) {
      return !state;
    }
    return state;
  },
);

final darkModeAtom = Atom(
  storage: storage,
  key: "darkMode",
  initialState: false,
  reducer: (state, action) {
    if (action is ToggleDarkMode) {
      updateStatusBar(!state);
      return !state;
    }
    return state;
  },
);

final textScaleAtom = Atom(
  storage: storage,
  key: "textScale",
  initialState: 0.0,
  reducer: (state, action) {
    if (action is UpdateTextScale) {
      return state += action.value;
    }
    return state;
  },
);

final savedBookAtom = Atom(
  storage: storage,
  key: "savedBook",
  initialState: 0,
  reducer: (state, action) {
    if (action is UpdateChapter) {
      return action.book;
    }
    return state;
  },
);

final savedChapterAtom = Atom(
  storage: storage,
  key: "savedChapter",
  initialState: 0,
  reducer: (state, action) {
    if (action is UpdateChapter) {
      return action.chapter;
    }
    return state;
  },
);

final isPlaying = Atom(
  key: "isPlaying",
  initialState: false,
  reducer: (state, action) {
    if (action is SetPlaying) {
      return action.value;
    }
    return state;
  },
);

final selectedVersesAtom = Atom<List<Verse>, AppAction>(
  key: "selectedVerses",
  initialState: [],
  reducer: (state, action) {
    if (action is SelectVerse) {
      if (isVerseSelected(action.verse)) {
        return (state as List<Verse>).removeBy((it) => it.index == action.verse.index).toList();
      } else {
        return (state as List<Verse>).addBy(action.verse).toList();
      }
    }
    if (action is ClearSelectedVerses) {
      return List<Verse>.from([]);
    }
    return state;
  },
);

Color? getHighlight(Verse v) {
  final key = "${v.book}:${v.chapter}:${v.index}:highlight";
  if (box.hasData(key)) {
// box.remove(key);
// print(box.read(key));
    final index = box.read<int>(key);
    if (index == null) {
      return null;
    }
    return darkModeAtom.value ? darkHighlights[index] : lightHighlights[index];
  }
  return null;
}

void setHighlight(BuildContext context, int index) {
  for (final v in selectedVersesAtom.value) {
    box.write("${v.book}:${v.chapter}:${v.index}:highlight", index);
  }
  box.save();
  hideActions(context);
}

void removeHighlight(BuildContext context) {
  for (final v in selectedVersesAtom.value) {
    box.remove("${v.book}:${v.chapter}:${v.index}:highlight");
  }
  box.save();
  hideActions(context);
}

bool isVerseSelected(Verse v) {
  return selectedVersesAtom.value.any((el) => el.book == v.book && el.chapter == v.chapter && el.index == v.index);
}

bool watchVerseSelected(BuildContext context, Verse v) {
  return selectedVersesAtom
      .watch(context)
      .any((el) => el.book == v.book && el.chapter == v.chapter && el.index == v.index);
}

void onVerseSelected(BuildContext context, Bible bible, Verse v) {
  dispatch(SelectVerse(v));
  if (selectedVersesAtom.value.isNotEmpty) {
    showActions(context, bible);
  }
  if (selectedVersesAtom.value.isEmpty) {
    hideActions(context);
  }
}

TextStyle getHighlightStyle(BuildContext context, Verse v) {
  if (watchVerseSelected(context, v)) {
    return TextStyle(
      backgroundColor: darkModeAtom.value ? Colors.grey.shade800 : Colors.grey.shade200,
    );
  }
  if (darkModeAtom.watch(context)) {
// return TextStyle(
//   color: getHighlight(v) ?? context.theme.colorScheme.onBackground,
// );
    return TextStyle(
      backgroundColor: getHighlight(v)?.withOpacity(0.7),
      color: getHighlight(v) != null ? Colors.white : context.theme.colorScheme.onBackground,
    );
  }
  return TextStyle(
    backgroundColor: getHighlight(v) ?? context.theme.colorScheme.background,
  );
}

clearEvents(BuildContext context) {
  if (isPlaying.value) {
    pause();
  }
  hideActions(context);
}

pause() async {
  await player.pause();
  dispatch(const SetPlaying(false));
}

class BufferAudioSource extends StreamAudioSource {
  final Uint8List _buffer;

  BufferAudioSource(this._buffer);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) {
    start = start ?? 0;
    end = end ?? _buffer.length;

    return Future.value(
      StreamAudioResponse(
        sourceLength: _buffer.length,
        contentLength: end - start,
        offset: start,
        contentType: "audio/mpeg",
        stream: Stream.value(List<int>.from(_buffer.skip(start).take(end - start))),
      ),
    );
  }
}

onPlay(BuildContext context, Bible bible) async {
  final versesToPlay = List<Verse>.from(selectedVersesAtom.value);
  if (isPlaying.value) {
    pause();
  } else {
    dispatch(const SetPlaying(true));
    for (final v in versesToPlay) {
      final directory = await getApplicationDocumentsDirectory();
      final pathname = "${bible.name}_${v.book}_${v.chapter}_${v.index}";
      final filepath = "${directory.path}/$pathname.mp3";
      try {
        final data = await convertText(context.currentLang.audioVoice, v.text);
        if (!kIsWeb) {
          await File(filepath).writeAsBytes(data);
          await player.setUrl("file:$filepath");
        } else {
          await player.setAudioSource(BufferAudioSource(data));
        }
        await player.play();
        await player.stop();
        if (!kIsWeb) {
          await File(filepath).delete();
        }
      } catch (err) {
        log("Could not play audio", name: "play", error: (err.toString(), pathname));
        recordError((err.toString(), pathname).toString(), null);
        if (context.mounted) {
          showError(context, context.l.audioError);
        }
        return;
      } finally {
        pause();
      }
    }
  }
}

bool hasNote(Verse v) {
  return box.hasData("${v.book}:${v.chapter}:${v.index}:note");
}

saveNote(BuildContext context, Verse v) {
  final note = noteTextController.text;
  box.write("${v.book}:${v.chapter}:${v.index}:note", note);
  box.save();
  hideNoteField(context);
  hideActions(context);
}

deleteNote(BuildContext context, Verse v) {
  box.remove("${v.book}:${v.chapter}:${v.index}:note");
  box.save();
  hideNoteField(context);
// TODO: hack to re-render this page
  selectedVersesAtom.notifyChanged();
}
