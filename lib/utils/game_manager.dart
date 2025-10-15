import 'package:undercover_game/models/player.dart';
import 'package:undercover_game/models/word.dart';

class GameManager {
  GameManager._privateConstructor();

  static final _instance = GameManager._privateConstructor();

  factory GameManager() {
    return _instance;
  }

  List<Player> players = [];
  int currentRound = 1;
  Word? currentWord;

  int timerDuration = 30;
  int currentTimeLeft = 0;
  bool isTimerRunning = false;

  void reset() {
    players.clear();
    currentRound = 1;
    currentWord = null;
    currentTimeLeft = 0;
    isTimerRunning = false;
  }

  void resetEliminationStatus() {
    for (var player in players) {
      player.isEliminated = false;
      player.isUndercover = false;
      player.points = 0;
    }
    currentRound = 1;
  }

  void startTimer() {
    currentTimeLeft = timerDuration;
    isTimerRunning = true;
  }

  void stopTimer() {
    isTimerRunning = false;
  }

  void resetTimer() {
    currentTimeLeft = timerDuration;
    isTimerRunning = false;
  }
}
