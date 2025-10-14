import 'package:flutter/material.dart';

class GameNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const GameNavigationBar({super.key, this.selectedIndex = 2});

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/change_word');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/players');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/describe');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/timer');
    } else if (index == 4) {
      Navigator.pushReplacementNamed(context, '/show_word');
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
