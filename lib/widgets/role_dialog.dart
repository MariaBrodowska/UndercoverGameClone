import 'package:flutter/material.dart';
import 'package:undercover_game/models/word.dart';

class RoleDialog extends StatelessWidget {
  final bool isUndercover;
  final String playerName;
  final Word chosenWord;

  const RoleDialog({
    super.key,
    required this.isUndercover,
    required this.playerName,
    required this.chosenWord,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isUndercover ? 'You are the Undercover!' : 'You are a Citizen!',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Player: $playerName',
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
    );
  }
}
