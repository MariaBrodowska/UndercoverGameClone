import 'package:flutter/material.dart';
import 'package:undercover_game/pages/cards_page.dart';
import 'package:undercover_game/pages/change_word_page.dart';
import 'package:undercover_game/pages/game_round_page.dart';
import 'package:undercover_game/pages/home_page.dart';
import 'package:undercover_game/pages/setup_page.dart';
import 'package:undercover_game/pages/players_list_page.dart';
import 'package:undercover_game/pages/timer_page.dart';
import 'package:undercover_game/pages/show_word_page.dart';
import 'package:undercover_game/pages/vote_page.dart';
import 'package:undercover_game/pages/ranking_page.dart';

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
        '/change_word': (context) => const ChangeWordPage(),
        '/describe': (context) => const GameRoundPage(),
        '/vote': (context) => const VotePage(),
        '/players': (context) => const PlayersListPage(),
        '/timer': (context) => const TimerPage(),
        '/show_word': (context) => const ShowWordPage(),
        '/ranking': (context) => const RankingPage(),
      },
    );
  }
}
