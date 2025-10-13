import 'package:flutter/material.dart';
import '../models/player.dart';
import '../utils/game_manager.dart';
import '../utils/validator.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  int numberOfPlayers = 3;
  List<Player> players = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    players = List.generate(numberOfPlayers, (index) => Player(name: ''));
  }

  void _updatePlayers(int newCount) {
    if (newCount > players.length) {
      players.addAll(
        List.generate(newCount - players.length, (index) => Player(name: '')),
      );
    } else if (newCount < players.length) {
      players = players.sublist(0, newCount);
    }
  }

  void _savePlayersToGameManager() {
    GameManager().players = List<Player>.from(players);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Player Setup"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Number Of Players"),
              Slider(
                value: numberOfPlayers.toDouble(),
                min: 3,
                max: 12,
                divisions: 9,
                label: numberOfPlayers.toString(),
                onChanged: (value) {
                  setState(() {
                    numberOfPlayers = value.toInt();
                    _updatePlayers(numberOfPlayers);
                  });
                },
              ),
              SizedBox(height: 20),
              Text("Enter Names"),
              SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: numberOfPlayers,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        initialValue: players[index].name,
                        onChanged: (value) {
                          players[index].name = value;
                        },
                        validator: (value) =>
                            validatePlayerName(value, index, players),
                        decoration: InputDecoration(
                          labelText: "Player ${index + 1}",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _savePlayersToGameManager();
                        Navigator.pushNamed(context, '/cards');
                      }
                    },
                    child: const Text("Continue"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
