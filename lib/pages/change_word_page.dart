import 'dart:math';
import 'package:flutter/material.dart';
import 'package:undercover_game/data/words.dart';
import 'package:undercover_game/models/word.dart';
import 'package:undercover_game/utils/game_manager.dart';
import '../widgets/game_navigation_bar.dart';
import '../widgets/role_dialog.dart';
import '../widgets/card_widget.dart';

class ChangeWordPage extends StatefulWidget {
  const ChangeWordPage({super.key});

  @override
  State<ChangeWordPage> createState() => _ChangeWordPageState();
}

class _ChangeWordPageState extends State<ChangeWordPage> {
  List players = [];
  int undercoverIndex = 0;
  Word chosenWord = Word("", "");
  int currentIndex = 0;
  List<bool> revealed = [];
  bool allowTap = true;

  @override
  void initState() {
    super.initState();
    players = List.of(GameManager().players)..shuffle();
    for (var player in players) {
      player.isUndercover = false;
    }
    undercoverIndex = Random().nextInt(players.length);
    players[undercoverIndex].isUndercover = true;
    chosenWord = (words..shuffle()).first;
    GameManager().currentWord = chosenWord;
    revealed = List.generate(players.length, (_) => false);
  }

  void _showRoleDialog(int userIndex, int cardIndex) {
    final index = userIndex;
    final isUndercover = index == undercoverIndex;
    setState(() {
      allowTap = false;
    });
    showDialog(
      context: context,
      builder: (_) => RoleDialog(
        isUndercover: isUndercover,
        playerName: players[index].name,
        chosenWord: chosenWord,
      ),
    ).then((_) {
      setState(() {
        revealed[cardIndex] = true;
        currentIndex++;
        allowTap = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Change Word'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      bottomNavigationBar: const GameNavigationBar(selectedIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 25),
            Text(
              currentIndex < players.length
                  ? "Now it's ${players[currentIndex].name}'s turn to reveal!"
                  : 'All cards have been revealed!',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                padding: const EdgeInsets.all(16),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return CardWidget(
                    isRevealed: revealed[index],
                    onTap: allowTap && currentIndex < players.length
                        ? () => _showRoleDialog(currentIndex, index)
                        : null,
                  );
                },
              ),
            ),
            if (currentIndex >= players.length)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/describe');
                  },
                  child: const Text("Continue to Game"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
