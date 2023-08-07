import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: "Roboto",
  primaryColor: const Color(0xFF4C2323),
  primaryColorDark: const Color(0xFF3C1B1C),
  primaryColorLight: const Color(0xFF7F3D3C),
  secondaryHeaderColor: const Color(0xFFFFB341),
  highlightColor: const Color(0xAAF8D0DC),
  hoverColor: const Color(0xAAF8D0DC),
  dividerColor: Colors.black,
  shadowColor: Colors.black,
  popupMenuTheme: const PopupMenuThemeData(
    enableFeedback: true,
    elevation: 4,
    // color: Colors.white,
    // shadowColor: Colors.black,
    // surfaceTintColor: Color(0xAAF8D0DC),
  ),
  colorScheme: const ColorScheme.light(
    background: Colors.white,
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      enableFeedback: true,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      enableFeedback: true,
      padding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      elevation: 1,
// backgroundColor: const Color(0xFFF6F6F6),
      backgroundColor: const Color(0xFFEAE9E9),
      foregroundColor: const Color(0xFF9A1111),
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xFF9A1111),
        letterSpacing: 0.5,
      ),
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      wordSpacing: 0,
      letterSpacing: 0,
      color: Color(0xFF010101),
    ),
    headlineLarge: TextStyle(
      fontSize: 38,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFB341),
    ),
    headlineMedium: TextStyle(
      color: Color(0xFF010101),
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Color(0xFF9A1111),
      letterSpacing: 0,
    ),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: "Roboto",
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: const Color(0xFF2D0B0B),
  primaryColorDark: const Color(0xFF260909),
  primaryColorLight: const Color(0xFF481514),
  secondaryHeaderColor: const Color(0xFFFFC351),
  highlightColor: const Color(0xAA5D4979),
  hoverColor: const Color(0xAA5D4979),
  dividerColor: Colors.white,
  shadowColor: Colors.white,
  // popupMenuTheme: lightTheme.popupMenuTheme.copyWith(
  //   color: Colors.black,
  //   surfaceTintColor: const Color(0xAA5D4979),
  // ),
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF1F1F22),
  ),
  iconButtonTheme: lightTheme.iconButtonTheme,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      enableFeedback: true,
      padding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      elevation: 1,
      backgroundColor: const Color(0xFF323232),
      foregroundColor: const Color(0xFFBC86FC),
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xFF9A1111),
        letterSpacing: 0.5,
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyMedium: lightTheme.textTheme.bodyMedium!.copyWith(
      color: const Color(0xFFBCBEC4),
    ),
    headlineLarge: lightTheme.textTheme.headlineLarge!.copyWith(
      color: const Color(0xFFFFC351),
    ),
    headlineMedium: lightTheme.textTheme.headlineMedium!.copyWith(
      color: const Color(0xFFBCBEC4),
    ),
    labelMedium: lightTheme.textTheme.labelMedium!.copyWith(
      color: const Color(0xFFBA50AB), //E24DE2
    ),
  ),
);
