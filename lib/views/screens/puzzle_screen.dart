import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:sorting_puzzle/views/functions/dialog.dart';
import 'package:sorting_puzzle/views/widgets/puzzle_grid.dart';
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

    showWinDialog(
      context,
      moves: numberOfMoves,
      seconds: seconds,
      onQuit: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      onPlayAgain: () {
        Navigator.pop(context);
        setState(() {
          tiles.shuffle();
          numberOfMoves = 0;
          statusText = "Tap a tile to select";
          firstTapIndex = null;
          startTimer();
        });
      },
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
            child: PuzzleGrid(
              tiles: tiles,
              firstTapIndex: firstTapIndex,
              onTileTap: onTileTap,
              confettiController: confettiController,
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
                    showStopDialog(
                      context,
                      onQuit: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      onContinue: () {
                        Navigator.pop(context);
                        resumeTimer();
                      },
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
