import 'package:flutter/material.dart';
import 'package:undercover_game/widgets/game_navigation_bar.dart';

class ShowWordPage extends StatefulWidget {
  const ShowWordPage({super.key});

  @override
  State<ShowWordPage> createState() => _ShowWordPageState();
}

class _ShowWordPageState extends State<ShowWordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Show Word'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      bottomNavigationBar: const GameNavigationBar(selectedIndex: 4),
      body: const Center(child: Text('Show Word Page')),
    );
  }
}
