class Player {
  String name;
  bool isUndercover;
  bool isEliminated;

  Player({
    required this.name,
    this.isUndercover = false,
    this.isEliminated = false,
  });
}
