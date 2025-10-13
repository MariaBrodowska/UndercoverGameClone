import 'package:flutter/material.dart';
import 'package:undercover_game/pages/cards_page.dart';
import 'package:undercover_game/pages/home_page.dart';
import 'package:undercover_game/pages/setup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/setup': (context) => const SetupPage(),
        '/cards': (context) => const CardsPage(),
      },
    );
  }
}
