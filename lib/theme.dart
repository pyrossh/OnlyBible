import "package:flutter/material.dart";

const lightHighlights = [
  Color(0xFFDAEFFE),
  Color(0xFFFFFCB2),
  Color(0xFFFFDDF3),
  Color(0xFFE6FCC3),
];

const darkHighlights = [
  Color(0xFF69A9FC),
  Color(0xFFFFEB66),
  Color(0xFFFF66B3),
  Color(0xFF48F334),
];

const lightColorScheme = ColorScheme.light(
  background: Colors.white,
  onBackground: Color(0xFF010101),
  primary: Color(0xFF9A1111),
  secondary: Color(0xFFFFC351),
  surfaceTint: Colors.black,
  shadow: Colors.black,
  outline: Colors.grey,
);

const darkColorScheme = ColorScheme.dark(
  background: Color(0xFF1F1F22),
  onBackground: Color(0xFFBCBEC4),
  primary: Color(0xFFBC86FC),
  secondary: Color(0xFFFFC351),
  tertiary: Color(0xFF323232),
  onTertiary: Color(0xFFBA50AB),
  //E24DE2
  surfaceTint: Colors.white,
  shadow: Colors.white,
  outline: Color(0xAA5D4979),
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  useMaterial3: true,
  fontFamily: "Roboto",
  primaryColor: const Color(0xFF602C2C),
  primaryColorDark: const Color(0xFF482122),
  primaryColorLight: const Color(0xFF8A4242),
  secondaryHeaderColor: const Color(0xFFFFB341),
  highlightColor: const Color(0xAAF8D0DC),
  hoverColor: const Color(0xAAF8D0DC),
  dividerColor: Colors.black,
  shadowColor: Colors.black,
  // textSelectionTheme: TextSelectionThemeData(
  //   cursorColor: Colors.black,
  //   selectionHandleColor: Colors.black,
  //   selectionColor: const Color(0xAAF8D0DC),
  // ),
  inputDecorationTheme: const InputDecorationTheme(
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    activeIndicatorBorder: BorderSide(
      color: Colors.black,
    ),
    hintStyle: TextStyle(color: Colors.grey),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.background,
    foregroundColor: lightColorScheme.onBackground,
    elevation: 1,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    elevation: 10,
    backgroundColor: Color(0xFFF2F2F7),
    shadowColor: Colors.black,
    surfaceTintColor: Color(0xFFF2F2F7),
    showDragHandle: true,
    dragHandleSize: Size(50, 3),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: Color(0xFFAFA8A8),
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
    ),
  ),
  dialogTheme: const DialogTheme(
    elevation: 10,
    // TODO: get this to inherit from top like darkTheme does
    shadowColor: Colors.black,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shape: Border(
      top: BorderSide(
        width: 1.5,
        color: Colors.black,
      ),
    ),
  ),
  popupMenuTheme: const PopupMenuThemeData(
    enableFeedback: true,
    elevation: 4,
    surfaceTintColor: Colors.transparent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0.5,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.white,
      backgroundColor: const Color(0xFFEAE9E9),
      foregroundColor: lightColorScheme.primary,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
    ),
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
      elevation: 0.5,
      shadowColor: Colors.black,
      backgroundColor: const Color(0xFFEAE9E9),
      foregroundColor: lightColorScheme.primary,
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      wordSpacing: 0,
      letterSpacing: 0,
      color: lightColorScheme.onBackground,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      wordSpacing: 0,
      letterSpacing: 0,
      color: lightColorScheme.onBackground,
    ),
    headlineLarge: TextStyle(
      fontSize: 38,
      fontWeight: FontWeight.w700,
      color: lightColorScheme.secondary,
    ),
    headlineMedium: TextStyle(
      color: lightColorScheme.onBackground,
      fontSize: 19,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: lightColorScheme.primary,
      letterSpacing: 0,
    ),
  ),
);

final darkTheme = lightTheme.copyWith(
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  primaryColor: const Color(0xFF4C2323),
  primaryColorDark: const Color(0xFF3C1B1C),
  primaryColorLight: const Color(0xFF7F3D3C),
  secondaryHeaderColor: const Color(0xFFFFC351),
  highlightColor: darkColorScheme.outline,
  hoverColor: darkColorScheme.outline,
  dividerColor: Colors.white,
  shadowColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.background,
    foregroundColor: darkColorScheme.onBackground,
    elevation: 1,
  ),
  bottomSheetTheme: lightTheme.bottomSheetTheme.copyWith(
    backgroundColor: const Color(0xFF141415),
    shadowColor: Colors.white,
    surfaceTintColor: const Color(0xFF141415),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: darkColorScheme.background,
    elevation: 1,
    shape: Border(
      top: BorderSide(
        width: 1.5,
        color: darkColorScheme.outline,
      ),
    ),
  ),
  popupMenuTheme: lightTheme.popupMenuTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0.5,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      backgroundColor: darkColorScheme.tertiary,
      foregroundColor: darkColorScheme.primary,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      enableFeedback: true,
      foregroundColor: Colors.white,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      enableFeedback: lightTheme.textButtonTheme.style!.enableFeedback,
      padding: lightTheme.textButtonTheme.style!.padding,
      shape: lightTheme.textButtonTheme.style!.shape,
      textStyle: lightTheme.textButtonTheme.style!.textStyle,
      elevation: MaterialStateProperty.all(1),
      shadowColor: MaterialStateProperty.all(Colors.white),
      backgroundColor: MaterialStateProperty.all(darkColorScheme.tertiary),
      foregroundColor: MaterialStateProperty.all(darkColorScheme.primary),
    ),
  ),
  textTheme: TextTheme(
    bodyMedium: lightTheme.textTheme.bodyMedium!.copyWith(
      color: darkColorScheme.onBackground,
    ),
    bodySmall: lightTheme.textTheme.bodyMedium!.copyWith(
      color: darkColorScheme.onBackground,
    ),
    headlineLarge: lightTheme.textTheme.headlineLarge!.copyWith(
      color: darkColorScheme.secondary,
    ),
    headlineMedium: lightTheme.textTheme.headlineMedium!.copyWith(
      color: darkColorScheme.onBackground,
    ),
    labelMedium: lightTheme.textTheme.labelMedium!.copyWith(
      color: darkColorScheme.onTertiary,
    ),
  ),
);
