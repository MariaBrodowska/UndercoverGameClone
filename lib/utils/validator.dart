import '../models/player.dart';

String? validatePlayerName(String? value, int index, List<Player> players) {
  final name = value?.trim() ?? '';
  if (name.isEmpty) {
    return 'Field is required';
  }
  for (int j = 0; j < players.length; j++) {
    if (j != index &&
        players[j].name.trim().toLowerCase() == name.toLowerCase()) {
      return 'Player names must be unique';
    }
  }
  return null;
}
