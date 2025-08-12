import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:sorting_puzzle/views/widgets/tile_widget.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreen();
}

class _PuzzleScreen extends State<PuzzleScreen> {
  List<int> tiles = List.generate(9, (index) => index);
  int? firstTapIndex;
  String statusText = "Tap a tile to select";
  int numberOfMoves = 0;
  int seconds = 0;
  Timer? timer;
  late AudioPlayer player;
  late ConfettiController confettiController;

  void startTimer() {
    timer?.cancel();
    seconds = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        seconds++;
      });
    });
  }

  void resumeTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void onTileTap(int gridIndex) {
    setState(() {
      if (firstTapIndex == null) {
        firstTapIndex = gridIndex;
        statusText = "Now tap another tile to swap";
      } else {
        numberOfMoves++;
        int temp = tiles[firstTapIndex!];
        tiles[firstTapIndex!] = tiles[gridIndex];
        tiles[gridIndex] = temp;
        firstTapIndex = null;
        if (tiles.asMap().entries.every((entry) => entry.key == entry.value)) {
          _win();
        } else {
          statusText = "Tap a tile to select";
        }
      }
    });
  }

  void _win() async {
    timer?.cancel();
    statusText = "Solved! 🎉";
    confettiController.play();
    await player.play(AssetSource('sounds/win_sound.mp3'));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Puzzle Solved!")));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: const [
                Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                SizedBox(width: 8),
                Text(
                  'Puzzle Solved!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(
              "🎉 Great job! You completed the puzzle.\nMoves: $numberOfMoves\nTime: ${seconds}s",
              style: TextStyle(fontSize: 16),
            ),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 26,
              vertical: 16,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Quit',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        tiles.shuffle();
                        numberOfMoves = 0;
                        statusText = "Tap a tile to select";
                        firstTapIndex = null;
                        startTimer();
                      });
                    },
                    child: const Text(
                      'play again',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    tiles.shuffle();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    player = AudioPlayer();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    confettiController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "Tile Swap Puzzle",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                timer?.cancel();
                tiles.shuffle();
                numberOfMoves = 0;
                statusText = "Tap a tile to select";
                firstTapIndex = null;
                startTimer();
              });
            },
            icon: Icon(Icons.shuffle_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Text(
            statusText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.teal,
            ),
          ),
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder:
                      (context, index) => TileWidget(
                        index: tiles[index],
                        isSelected: firstTapIndex == index,
                        onTap: () => onTileTap(index),
                      ),
                  itemCount: 9,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "Moves: $numberOfMoves  |  Time: ${seconds}s",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 26),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    stopTimer();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Row(
                              children: const [
                                Icon(
                                  Icons.stop_outlined,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Stop Puzzle',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            content: Text(
                              "CONTINUE?",
                              style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),
                            ),
                            actionsPadding: const EdgeInsets.symmetric(
                              horizontal: 26,
                              vertical: 16,
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Quit',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      resumeTimer();
                                    },
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    );
                  },
                  child: const Text(
                    'Stop',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
