import 'package:flutter/material.dart';
import 'package:undercover_game/widgets/game_navigation_bar.dart';

class VotePage extends StatefulWidget {
  const VotePage({super.key});

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Vote'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      bottomNavigationBar: const GameNavigationBar(selectedIndex: 2),
      body: const Center(child: Text('Vote Page')),
    );
  }
}
