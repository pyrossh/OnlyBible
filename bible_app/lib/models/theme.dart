import "package:flutter/material.dart";
import "package:flutter/services.dart";

const lightPrimary = Color(0xFF4C2323);
const lightPrimaryLighter = Color(0xFF3C1B1C);
const lightSecondary = Color(0xFFFFB341);
const lightTertiary = Color(0xFF4C2323);
const lightHeadline = Color(0xFF010101);
const lightLabel = Color(0xFF9A1111);
const lightBody = Color(0xFF010101);
const lightHighlightColor = Color(0xAAF8D0DC);

const lightStatusBar = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
);

const darkStatusBar = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.black,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarColor: Colors.black,
  statusBarIconBrightness: Brightness.light,
);

const lightTheme = AppTheme(
  secondaryColor: lightSecondary,
  highlightColor: lightHighlightColor,
  labelText: TextStyle(
    // fontFamily: "SanFrancisco",
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: lightLabel,
    letterSpacing: 0.5,
  ),
  logoText: TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w700,
    color: lightSecondary,
  ),
  bodyText: TextStyle(
    color: lightBody,
    fontSize: 16,
    // fontFamily: "SanFranciscoPro",
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.5,
  ),
  headerText: TextStyle(
    // color: lightLabel,
    color: lightBody,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  ),
  titleText: TextStyle(
    color: lightBody,
    fontWeight: FontWeight.w600,
    fontSize: 20,
  ),
  tileText: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: lightLabel,
    letterSpacing: 0.5,
  ),
);

class AppTheme {
  const AppTheme({
    required this.labelText,
    required this.logoText,
    required this.bodyText,
    required this.headerText,
    required this.titleText,
    required this.tileText,
    required this.secondaryColor,
    required this.highlightColor,
  });

  final TextStyle labelText;
  final TextStyle logoText;
  final TextStyle bodyText;
  final TextStyle headerText;
  final TextStyle titleText;
  final TextStyle tileText;
  final Color secondaryColor;
  final Color highlightColor;
}
