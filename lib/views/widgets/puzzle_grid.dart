import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:sorting_puzzle/views/widgets/tile_widget.dart';

class PuzzleGrid extends StatelessWidget {
  final List<int> tiles;
  final int? firstTapIndex;
  final Function(int) onTileTap;
  final ConfettiController confettiController;

  const PuzzleGrid({
    super.key,
    required this.tiles,
    required this.firstTapIndex,
    required this.onTileTap,
    required this.confettiController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}
