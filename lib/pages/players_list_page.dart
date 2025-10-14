import 'package:flutter/material.dart';
import 'package:undercover_game/models/player.dart';
import 'package:undercover_game/utils/game_manager.dart';
import 'package:undercover_game/widgets/game_navigation_bar.dart';

class PlayersListPage extends StatefulWidget {
  const PlayersListPage({super.key});

  @override
  State<PlayersListPage> createState() => _PlayersListPageState();
}

class _PlayersListPageState extends State<PlayersListPage> {
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    players = List.from(GameManager().players);
  }

  void _addPlayer() {
    showDialog(
      context: context,
      builder: (context) {
        String newName = '';
        return AlertDialog(
          title: const Text('Add New Player'),
          content: TextField(
            onChanged: (value) => newName = value,
            decoration: const InputDecoration(
              hintText: 'Enter player name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newName.trim().isNotEmpty) {
                  setState(() {
                    players.add(Player(name: newName.trim()));
                    GameManager().players = players;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editPlayer(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String newName = players[index].name;
        return AlertDialog(
          title: const Text('Edit Player'),
          content: TextField(
            controller: TextEditingController(text: newName),
            onChanged: (value) => newName = value,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newName.trim().isNotEmpty) {
                  setState(() {
                    players[index].name = newName.trim();
                    GameManager().players = players;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deletePlayer(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Player'),
          content: Text(
            'Are you sure you want to delete ${players[index].name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  players.removeAt(index);
                  GameManager().players = players;
                });
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Players List'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      bottomNavigationBar: const GameNavigationBar(selectedIndex: 1),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlayer,
        child: const Icon(Icons.add),
      ),
      body: players.isEmpty
          ? const Center(
              child: Text(
                'No players added yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: players.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      players[index].name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editPlayer(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePlayer(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
