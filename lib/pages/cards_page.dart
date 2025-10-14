import 'dart:math';
import 'package:flutter/material.dart';
import 'package:undercover_game/data/words.dart';
import 'package:undercover_game/models/word.dart';
import 'package:undercover_game/utils/game_manager.dart';
import '../widgets/role_dialog.dart';
import '../widgets/card_widget.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
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
    undercoverIndex = Random().nextInt(players.length);
    chosenWord = (words..shuffle()).first;
    revealed = List.generate(players.length, (_) => false);
  }

  void _showRoleDialog(int userIndex, int cardIndex) {
    final isUndercover = userIndex == undercoverIndex;
    if (isUndercover) {
      players[userIndex].isUndercover = true;
    }
    setState(() {
      allowTap = false;
    });
    showDialog(
      context: context,
      builder: (_) => RoleDialog(
        isUndercover: isUndercover,
        playerName: players[userIndex].name,
        chosenWord: chosenWord,
      ),
    ).then((_) {
      setState(() {
        revealed[cardIndex] = true;
        currentIndex++;
        allowTap = true;
      });

      if (currentIndex >= players.length) {
        Future.delayed(const Duration(milliseconds: 100), () {
          Navigator.pushReplacementNamed(context, '/describe');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw Your Card'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Text(
              "Now it's ${players[currentIndex].name}'s turn to reveal!",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
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
          ],
        ),
      ),
    );
  }
}
