import "dart:ui";
import "package:flutter/material.dart";

class ThemeColors {
  final Color primary;

  const ThemeColors({
    required this.primary,
    // required Color primaryLight,
    // required Color secondary,
    // required Color tertiary,
    // required Color headerText,
    // required Color verseNo,
    // required Color verseText,
  });
}

class Theme {
  const Theme({required TextStyle body});
}

const lightColors = ThemeColors(
  primary: Color(0xFF4C2323),
  // primaryLight: Color(0xFF3C1B1C),
  // secondary: Color(0xFFFFB341),
  // tertiary: Color(0xFF4C2323),
  // headerText:  Color(0xFF010101),
  // verseNo: Color(0xFF9A1111),
  // verseText: Color(0xFF010101),
);

const lightPrimary = Color(0xFF4C2323);

const lightTheme = Theme(
  body: TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontFamily: "SanFranciscoPro",
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.5,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF4C2323),
  secondaryHeaderColor: const Color(0xFFFFB341),
  highlightColor: const Color(0xAAF8D0DC),
  fontFamily: "SanFranciscoPro",
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Color(0xFF010101),
      fontSize: 16,
      fontFamily: "SanFranciscoPro",
      fontWeight: FontWeight.w400,
// letterSpacing: 0.5,
    ),
    headlineLarge: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    headlineMedium: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
    labelMedium: TextStyle(
      fontFamily: "SanFrancisco",
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontFamily: "SanFrancisco",
      fontSize: 12,
      fontWeight: FontWeight.w800,
      color: Color(0xFF9A1111),
      letterSpacing: 0.5,
    ),
    labelLarge: TextStyle(
      fontSize: 38,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFB341),
    ),
  ),
);
