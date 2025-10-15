import 'package:flutter/material.dart';
import 'package:undercover_game/data/words.dart';
import 'package:undercover_game/utils/game_manager.dart';
import 'package:undercover_game/widgets/game_navigation_bar.dart';
import 'package:undercover_game/models/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VotePage extends StatefulWidget {
  const VotePage({super.key});

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  final gameManager = GameManager();
  final Map<String, int> votes = {};
  final Map<String, String> whoVotedFor = {};
  int currentVoterIndex = 0;
  bool showResults = false;
  String? selectedPlayer;
  bool isTie = false;
  String? eliminatedPlayer;
  int totalVotesCast = 0;

  List<Player> activePlayers() {
    return gameManager.players.where((p) => !p.isEliminated).toList();
  }

  void castVote() {
    if (selectedPlayer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose player to eliminate!')),
      );
      return;
    }

    setState(() {
      final currentVoter = activePlayers()[currentVoterIndex];
      whoVotedFor[currentVoter.name] = selectedPlayer!;
      votes[selectedPlayer!] = (votes[selectedPlayer!] ?? 0) + 1;
      totalVotesCast++;
      selectedPlayer = null;

      if (totalVotesCast == activePlayers().length) {
        final sortedVotes = votes.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        isTie =
            sortedVotes.length > 1 &&
            sortedVotes[0].value == sortedVotes[1].value;

        if (!isTie && sortedVotes.isNotEmpty) {
          final playerToEliminate = gameManager.players.firstWhere(
            (p) => p.name == sortedVotes[0].key,
          );
          eliminatedPlayer = playerToEliminate.name;
          playerToEliminate.isEliminated = true;
        }

        showResults = true;
      } else {
        currentVoterIndex++;
      }
    });
  }

  void goToNextRound() {
    calculateAndSavePoints();
    setState(() {
      gameManager.currentRound++;
      votes.clear();
      whoVotedFor.clear();
      currentVoterIndex = 0;
      showResults = false;
      isTie = false;
      totalVotesCast = 0;
      eliminatedPlayer = null;
      gameManager.currentWord = (words..shuffle()).first;
    });
    Navigator.pushReplacementNamed(context, '/describe');
  }

  bool isUndercoverEliminated() {
    return gameManager.players.any((p) => p.isUndercover && p.isEliminated);
  }

  bool canContinueGame() {
    final activePlayerCount = activePlayers().length;
    return !isUndercoverEliminated() && activePlayerCount > 2;
  }

  bool shouldShowWinScreen() {
    return isUndercoverEliminated() || activePlayers().length <= 2;
  }

  void calculateAndSavePoints() {
    for (var player in gameManager.players) {
      if (player.isUndercover) {
        if (!player.isEliminated) player.addPoints(10);
        player.addPoints(-5 * (votes[player.name] ?? 0));
      } else {
        if (!player.isEliminated) player.addPoints(5);
        final votedFor = whoVotedFor[player.name];
        if (votedFor != null) {
          final votedPlayer = gameManager.players.firstWhere(
            (p) => p.name == votedFor,
          );
          if (votedPlayer.isUndercover) player.addPoints(3);
        }
      }
    }
  }

  Future<void> saveRankings() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> citizenNames = prefs.getStringList('citizen_names') ?? [];
    List<String> citizenScores = prefs.getStringList('citizen_scores') ?? [];
    List<String> undercoverNames =
        prefs.getStringList('undercover_names') ?? [];
    List<String> undercoverScores =
        prefs.getStringList('undercover_scores') ?? [];

    for (var player in gameManager.players) {
      if (player.points > 0) {
        if (player.isUndercover) {
          undercoverNames.add(player.name);
          undercoverScores.add(player.points.toString());
        } else {
          citizenNames.add(player.name);
          citizenScores.add(player.points.toString());
        }
      }
    }

    await prefs.setStringList('citizen_names', citizenNames);
    await prefs.setStringList('citizen_scores', citizenScores);
    await prefs.setStringList('undercover_names', undercoverNames);
    await prefs.setStringList('undercover_scores', undercoverScores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(showResults ? 'Results' : 'Voting'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      bottomNavigationBar: const GameNavigationBar(selectedIndex: 2),
      body: showResults ? buildResults() : buildVotingScreen(),
    );
  }

  Widget buildVotingScreen() {
    final currentVoter = activePlayers()[currentVoterIndex];
    final votablePlayers = activePlayers()
        .where((p) => p.name != currentVoter.name)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.white70,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.person, size: 48, color: Colors.indigo),
                  const SizedBox(height: 8),
                  Text(
                    currentVoter.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Voting (${currentVoterIndex + 1}/${activePlayers().length})',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Choose player to eliminate:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: votablePlayers.length,
              itemBuilder: (context, index) {
                final player = votablePlayers[index];
                final isSelected = selectedPlayer == player.name;

                return Card(
                  elevation: isSelected ? 8 : 2,
                  color: isSelected ? Colors.indigo[500] : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? Colors.indigo
                          : Colors.grey[300],
                      child: Text(
                        player.name[0].toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      player.name,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.indigo)
                        : const Icon(Icons.radio_button_unchecked),
                    onTap: () {
                      setState(() {
                        selectedPlayer = player.name;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: castVote,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Confirm vote',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResults() {
    final sortedPlayers = votes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.indigo[500],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.how_to_vote, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  const Text(
                    'All players voted',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (eliminatedPlayer != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '$eliminatedPlayer eliminated!',
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
                  if (isTie)
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Tie! No one eliminated',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[300],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Voting results:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: sortedPlayers.length,
              itemBuilder: (context, index) {
                final player = sortedPlayers[index];
                final playerName = player.key;
                final voteCount = player.value;
                final wasEliminated = playerName == eliminatedPlayer;

                return Card(
                  color: wasEliminated ? Colors.red[200] : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: wasEliminated
                          ? Colors.red
                          : Colors.grey[300],
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: wasEliminated ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      playerName,
                      style: TextStyle(
                        fontWeight: wasEliminated
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: wasEliminated ? Colors.black : Colors.white,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: wasEliminated ? Colors.red : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$voteCount ${voteCount == 1 ? 'vote' : 'votes'}',
                        style: TextStyle(
                          color: wasEliminated ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (canContinueGame())
            ElevatedButton(
              onPressed: goToNextRound,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Next Round',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          else if (shouldShowWinScreen())
            if (isUndercoverEliminated())
              Column(
                children: [
                  const Text(
                    'Citizens Win!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      calculateAndSavePoints();
                      await saveRankings();
                      gameManager.reset();
                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      }
                    },
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      GameManager().resetEliminationStatus();
                      Navigator.pushReplacementNamed(context, '/change_word');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange, width: 2),
                    ),
                    child: const Text(
                      "Reset & New Round",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Text(
                    'Undercover Win!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      calculateAndSavePoints();
                      await saveRankings();
                      gameManager.reset();
                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      }
                    },
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      GameManager().resetEliminationStatus();
                      Navigator.pushReplacementNamed(context, '/change_word');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange, width: 2),
                    ),
                    child: const Text(
                      "Reset & New Round",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
