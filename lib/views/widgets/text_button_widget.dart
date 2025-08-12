import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  TextButtonWidget({super.key, required this.onPressed, required this.child});
  void Function() onPressed;
  Widget child;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(120, 40),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 1,
        shadowColor: Colors.black,
      ),
      onPressed: () => onPressed(),
      child: child,
    );
  }
}
