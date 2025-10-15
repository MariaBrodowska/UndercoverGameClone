import 'package:flutter/material.dart';
import 'package:undercover_game/models/player.dart';
import 'package:undercover_game/utils/game_manager.dart';
import '../widgets/game_navigation_bar.dart';
import '../widgets/timer_widget.dart';

class GameRoundPage extends StatefulWidget {
  const GameRoundPage({super.key});

  @override
  State<GameRoundPage> createState() => _GameRoundPageState();
}

class _GameRoundPageState extends State<GameRoundPage> {
  List<Player> players = List.of(GameManager().players)..shuffle();

  List<Player> activePlayers() {
    return GameManager().players.where((p) => !p.isEliminated).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Description Time'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      bottomNavigationBar: const GameNavigationBar(selectedIndex: 2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(height: 25),
              const Text(
                "Describe your secret word in the indicated order, using just a word or phrase.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              Text(
                "Round ${GameManager().currentRound}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const TimerWidget(),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  padding: const EdgeInsets.all(16),
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    final isEliminated = player.isEliminated;
                    return GestureDetector(
                      child: Card(
                        color: Colors.black,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isEliminated
                                ? Colors.grey.shade700
                                : Colors.indigo,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_2,
                              size: 60,
                              color: isEliminated
                                  ? Colors.grey[700]
                                  : Colors.indigo,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '#${index + 1} ${player.name}',
                              style: TextStyle(
                                color: isEliminated
                                    ? Colors.grey[700]
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: activePlayers().length >= 3
                    ? () {
                        Navigator.pushNamed(context, '/vote');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: activePlayers().length >= 3
                      ? Colors.indigo
                      : Colors.grey,
                ),
                child: Text(
                  activePlayers().length >= 3
                      ? "Go to Vote"
                      : "Not enough players (min 3)",
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  GameManager().resetEliminationStatus();
                  Navigator.pushReplacementNamed(context, '/change_word');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.orange, width: 2),
                ),
                child: const Text(
                  "Reset & New Round",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
