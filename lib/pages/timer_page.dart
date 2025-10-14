import 'package:flutter/material.dart';
import 'package:undercover_game/utils/game_manager.dart';
import 'package:undercover_game/widgets/game_navigation_bar.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Timer Settings'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      bottomNavigationBar: const GameNavigationBar(selectedIndex: 3),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 25),
            const Text(
              'Set how much time each player has to describe their word',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 45),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Timer Duration',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (GameManager().timerDuration > 15) {
                              setState(() {
                                GameManager().timerDuration -= 15;
                                if (!GameManager().isTimerRunning) {
                                  GameManager().currentTimeLeft =
                                      GameManager().timerDuration;
                                }
                              });
                            }
                          },
                          icon: const Icon(Icons.remove_circle, size: 40),
                          color: Colors.red,
                        ),
                        const SizedBox(width: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.indigo[50],
                            border: Border.all(color: Colors.indigo),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${GameManager().timerDuration} seconds',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        IconButton(
                          onPressed: () {
                            if (GameManager().timerDuration < 300) {
                              setState(() {
                                GameManager().timerDuration += 15;
                                if (!GameManager().isTimerRunning) {
                                  GameManager().currentTimeLeft =
                                      GameManager().timerDuration;
                                }
                              });
                            }
                          },
                          icon: const Icon(Icons.add_circle, size: 40),
                          color: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Range: 15-300 seconds',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
