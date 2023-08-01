extension StringExtension on String {
  String bookShortName() {
    // final name = replaceAll(" ", "").substring(0, 3);
    if (this[0] == "1" || this[0] == "2" || this[0] == "3") {
      return "${this[0]}${this[2].toUpperCase()}${substring(3, 4).toLowerCase()}";
    }
    return "${this[0].toUpperCase()}${substring(1, 3).toLowerCase()}";
  }
}