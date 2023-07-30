import 'package:bible_app/screens/home.dart';
import 'package:flutter/material.dart';

final List<int> selectedVerses = [];

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // fontFamily: "SanFranciscoPro",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
