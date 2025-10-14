import 'dart:async';
import 'package:flutter/material.dart';
import 'package:undercover_game/utils/game_manager.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _gameTimer;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    if (GameManager().currentTimeLeft == 0) {
      GameManager().currentTimeLeft = GameManager().timerDuration;
    }
    _startUpdateTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _updateTimer?.cancel();
    super.dispose();
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (!GameManager().isTimerRunning &&
              GameManager().currentTimeLeft != GameManager().timerDuration) {
            GameManager().currentTimeLeft = GameManager().timerDuration;
          }
        });
      }
    });
  }

  void _startTimer() {
    if (GameManager().isTimerRunning) return;

    GameManager().isTimerRunning = true;
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GameManager().currentTimeLeft > 0) {
        GameManager().currentTimeLeft--;
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _gameTimer?.cancel();
    GameManager().isTimerRunning = false;
  }

  void _resetTimer() {
    _gameTimer?.cancel();
    GameManager().isTimerRunning = false;
    GameManager().currentTimeLeft = GameManager().timerDuration;
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(GameManager().currentTimeLeft),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: GameManager().currentTimeLeft <= 5
                    ? Colors.red
                    : GameManager().currentTimeLeft <= 10
                    ? Colors.orange
                    : Colors.indigo,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: GameManager().isTimerRunning
                      ? _stopTimer
                      : _startTimer,
                  icon: Icon(
                    GameManager().isTimerRunning
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  label: Text(GameManager().isTimerRunning ? 'Stop' : 'Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GameManager().isTimerRunning
                        ? Colors.red
                        : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
