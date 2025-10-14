import 'package:flutter/material.dart';
import 'package:undercover_game/utils/game_manager.dart';
import 'package:undercover_game/widgets/game_navigation_bar.dart';

class ShowWordPage extends StatefulWidget {
  const ShowWordPage({super.key});

  @override
  State<ShowWordPage> createState() => _ShowWordPageState();
}

class _ShowWordPageState extends State<ShowWordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Show Word'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      bottomNavigationBar: const GameNavigationBar(selectedIndex: 4),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 25),
            const Text(
              'Tap your name to see your word',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: GameManager().players.length,
                itemBuilder: (context, index) {
                  final player = GameManager().players[index];
                  return Card(
                    child: ListTile(
                      title: Text(player.name),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirmation'),
                            content: Text(
                              'Are you ${player.name}? Do you want to see your word?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  final isUndercover = player.isUndercover;
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('${player.name}\'s Word'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            isUndercover
                                                ? 'UNDERCOVER'
                                                : 'CITIZEN',
                                            style: TextStyle(
                                              color: isUndercover
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            isUndercover
                                                ? GameManager()
                                                          .currentWord
                                                          ?.undercoverWord ??
                                                      'No word'
                                                : GameManager()
                                                          .currentWord
                                                          ?.citizenWord ??
                                                      'No word',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text('Yes, show my word'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
