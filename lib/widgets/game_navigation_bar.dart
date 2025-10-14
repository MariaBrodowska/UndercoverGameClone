import 'package:flutter/material.dart';
import 'package:undercover_game/utils/game_manager.dart';

class GameNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const GameNavigationBar({super.key, this.selectedIndex = 2});

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == 0) {
      _checkPlayersAndNavigate(context, '/change_word');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/players');
    } else if (index == 2) {
      _checkPlayersAndNavigate(context, '/describe');
    } else if (index == 3) {
      _checkPlayersAndNavigate(context, '/timer');
    } else if (index == 4) {
      _checkPlayersAndNavigate(context, '/show_word');
    }
  }

  void _checkPlayersAndNavigate(BuildContext context, String route) {
    if (GameManager().players.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'At least 3 players are required to start the game!',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red[400],
        ),
      );
      Navigator.pushReplacementNamed(context, '/players');
    } else {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) =>
          _onDestinationSelected(context, index),
      destinations: [
        NavigationDestination(icon: Icon(Icons.refresh), label: 'Change Word'),
        NavigationDestination(
          icon: Icon(Icons.format_list_numbered),
          label: 'Players',
        ),
        NavigationDestination(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.indigo,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.home, color: Colors.white, size: 24),
            ),
          ),
          label: '',
        ),
        NavigationDestination(icon: Icon(Icons.av_timer), label: 'Timer'),
        NavigationDestination(
          icon: Icon(Icons.lightbulb_outline),
          label: 'Show Word',
        ),
      ],
    );
  }
}
