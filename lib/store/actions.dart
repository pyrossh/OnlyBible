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