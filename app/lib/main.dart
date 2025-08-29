import 'package:app/playgrounds/playground_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.highContrastLight(),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: PlaygroundPage(),
    );
  }
}
