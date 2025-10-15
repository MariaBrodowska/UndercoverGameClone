import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:undercover_game/models/ranking_entry.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  bool showCitizens = true;
  List<RankingEntry> citizenRankings = [];
  List<RankingEntry> undercoverRankings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRankings();
  }

  Future<void> loadRankings() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> citizenNames = prefs.getStringList('citizen_names') ?? [];
    List<String> citizenScores = prefs.getStringList('citizen_scores') ?? [];
    List<RankingEntry> tempCitizens = [];
    for (int i = 0; i < citizenNames.length; i++) {
      tempCitizens.add(
        RankingEntry(
          name: citizenNames[i],
          points: int.parse(citizenScores[i]),
        ),
      );
    }
    tempCitizens.sort((a, b) => b.points.compareTo(a.points));

    List<String> undercoverNames =
        prefs.getStringList('undercover_names') ?? [];
    List<String> undercoverScores =
        prefs.getStringList('undercover_scores') ?? [];
    List<RankingEntry> tempUndercovers = [];
    for (int i = 0; i < undercoverNames.length; i++) {
      tempUndercovers.add(
        RankingEntry(
          name: undercoverNames[i],
          points: int.parse(undercoverScores[i]),
        ),
      );
    }
    tempUndercovers.sort((a, b) => b.points.compareTo(a.points));

    setState(() {
      citizenRankings = tempCitizens.take(50).toList();
      undercoverRankings = tempUndercovers.take(50).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rankings'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showCitizens = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showCitizens
                          ? Colors.green
                          : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Citizens',
                      style: TextStyle(
                        color: showCitizens ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showCitizens = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !showCitizens
                          ? Colors.red
                          : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Undercovers',
                      style: TextStyle(
                        color: !showCitizens ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : buildRankingsList(),
          ),
        ],
      ),
    );
  }

  Widget buildRankingsList() {
    final rankings = showCitizens ? citizenRankings : undercoverRankings;

    if (rankings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No rankings yet!',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final entry = rankings[index];

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: showCitizens ? Colors.green : Colors.red,
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(entry.name),
            trailing: Text(
              '${entry.points} pts',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
