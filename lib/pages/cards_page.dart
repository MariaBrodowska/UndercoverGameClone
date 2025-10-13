import 'dart:math';
import 'package:flutter/material.dart';
import 'package:undercover_game/data/words.dart';
import 'package:undercover_game/models/word.dart';
import 'package:undercover_game/utils/game_manager.dart';

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
      builder: (_) => AlertDialog(
        title: Text(
          isUndercover ? 'You are the Undercover!' : 'You are a Citizen!',
        ),
        content: Text(
          isUndercover
              ? 'Your word: ${chosenWord.undercoverWord}'
              : 'Your word: ${chosenWord.citizenWord}',
          style: const TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
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
        title: const Text('Draw Your Card'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          SizedBox(height: 25),
          Text(
            currentIndex < players.length
                ? "Now it's ${players[currentIndex].name}'s turn to reveal!"
                : 'All cards have been revealed!',
            style: const TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              padding: const EdgeInsets.all(16),
              itemCount: players.length,
              itemBuilder: (context, index) {
                if (revealed[index]) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: allowTap && currentIndex < players.length
                      ? () => _showRoleDialog(currentIndex, index)
                      : null,
                  child: Card(
                    color: Colors.black,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.indigo, width: 1),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.visibility_off,
                        size: 60,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (currentIndex < players.length)
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/setup');
              },
              child: const Text("Start Game"),
            ),
        ],
      ),
    );
  }
}
