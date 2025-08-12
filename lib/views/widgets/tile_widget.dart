import 'package:flutter/material.dart';

class TileWidget extends StatelessWidget {
  TileWidget({
    super.key,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });
  int index;
  bool isSelected;
  void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            "$index",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
