import 'package:flutter/material.dart';
import 'package:undercover_game/pages/home_page.dart';

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
      // home: Scaffold(
      //   appBar: AppBar(title: Text("Undercover"), centerTitle: true),
      // ),
      initialRoute: '/',
      routes: {'/': (context) => const HomePage()},
    );
  }
}
