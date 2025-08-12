import 'package:flutter/material.dart';
import 'package:sorting_puzzle/views/screens/home_screen.dart';

void main() {
  runApp(const SortingPuzzle());
}

class SortingPuzzle extends StatelessWidget {
  const SortingPuzzle({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sorting Puzzle',
      home: HomeScreen(),
    );
  }
}
