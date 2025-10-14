import 'dart:math';
import 'package:flutter/material.dart';
import 'package:undercover_game/data/words.dart';
import 'package:undercover_game/models/word.dart';
import 'package:undercover_game/utils/game_manager.dart';
import '../widgets/game_navigation_bar.dart';

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
    undercoverIndex = Random().nextInt(players.length);
    chosenWord = (words..shuffle()).first;
    revealed = List.generate(players.length, (_) => false);
  }

  void _showRoleDialog(int tappedIndex) {
    final index = currentIndex;
    final isUndercover = index == undercoverIndex;
    setState(() {
      allowTap = false;
    });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          isUndercover ? 'You are the Undercover!' : 'You are a Citizen!',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Player: ${players[index].name}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              isUndercover
                  ? 'Your word: ${chosenWord.undercoverWord}'
                  : 'Your word: ${chosenWord.citizenWord}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
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
        revealed[currentIndex] = true;
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
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            currentIndex < players.length
                ? "Now it's ${players[currentIndex].name}'s turn to reveal!"
                : 'All cards have been revealed!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              padding: const EdgeInsets.all(16),
              itemCount: players.length,
              itemBuilder: (context, index) {
                if (revealed[index]) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: allowTap && currentIndex < players.length
                      ? () => _showRoleDialog(index)
                      : null,
                  child: Card(
                    color: Colors.indigo,
                    elevation: 4,
                    child: Center(
                      child: Icon(
                        Icons.visibility,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
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
    );
  }
}
