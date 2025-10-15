class Player {
  String name;
  bool isUndercover;
  bool isEliminated;
  int points;

  Player({
    required this.name,
    this.isUndercover = false,
    this.isEliminated = false,
    this.points = 0,
  });

  void addPoints(int amount) {
    points += amount;
  }

  void resetPoints() {
    points = 0;
  }
}
