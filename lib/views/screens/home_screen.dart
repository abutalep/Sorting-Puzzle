import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sorting_puzzle/views/screens/puzzel_screen.dart';
import 'package:sorting_puzzle/views/widgets/text_button_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Spacer(),
          Image.asset("assets/images/logo.webp"),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade300, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Sorting Puzzle\n\n",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: "How to play!",
                        style: TextStyle(color: Colors.white60, fontSize: 22),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "1-Tap a tile to select.\n",
                    style: TextStyle(fontSize: 20, color: Colors.white60),
                    children: [
                      TextSpan(text: "2-Tap another tile to swap them.\n"),
                      TextSpan(text: "3-Sorting tiles inthe correct order.\n"),
                      TextSpan(text: "4-.Make moves and time the least.\n"),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white60,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          TextButtonWidget(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PuzzleScreen()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.games_outlined, color: Colors.blue, size: 40),
                SizedBox(width: 10),
                Text(
                  "Play Now",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          TextButtonWidget(
            onPressed: () {
              exit(0);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Exit",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  IconData(0xe243, fontFamily: 'MaterialIcons'),
                  color: Colors.red,
                  size: 30,
                ),
              ],
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
