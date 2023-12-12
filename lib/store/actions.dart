import "package:only_bible_app/models.dart";

sealed class AppAction {}

class FirstOpenDone implements AppAction {}

class UpdateBible implements AppAction {
  final String name;
  final String code;

  const UpdateBible(this.name, this.code);
}

class ToggleEngTitles implements AppAction {}

class ToggleBoldFont implements AppAction {}

class ToggleDarkMode implements AppAction {}

class UpdateTextScale implements AppAction {
  final double value;

  const UpdateTextScale(this.value);
}

class UpdateChapter implements AppAction {
  final int book;
  final int chapter;

  const UpdateChapter(this.book, this.chapter);
}

class SetPlaying implements AppAction {
  final bool value;

  const SetPlaying(this.value);
}

class SelectVerse implements AppAction {
  final Verse verse;

  const SelectVerse(this.verse);
}


class ClearSelectedVerses implements AppAction {
  const ClearSelectedVerses();
}
