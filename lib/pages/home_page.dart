import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.visibility_off, size: 100, color: Colors.indigo),
            const SizedBox(height: 32),
            const Text(
              "Undercover Game",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/setup');
              },
              child: const Text("Start Game"),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/ranking');
              },
              icon: const Icon(Icons.emoji_events),
              label: const Text("View Rankings"),
            ),
          ],
        ),
      ),
    );
  }
}
