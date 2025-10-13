import 'package:undercover_game/models/player.dart';

class GameManager {
  GameManager._privateConstructor();

  static final _instance = GameManager._privateConstructor();

  factory GameManager() {
    return _instance;
  }

  List<Player> players = [];
  int currentRound = 1;

  void reset() {
    players.clear();
    currentRound = 1;
  }
}
