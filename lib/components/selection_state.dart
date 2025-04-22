import 'package:flutter/material.dart';

class SelectionState extends StatefulWidget {
  final String text;
  final bool isClicked;
  final VoidCallback onPressed;

  const SelectionState({super.key, required this.text, required this.isClicked, required this.onPressed});

  @override
  _SelectionStateState createState() => _SelectionStateState();
}

class _SelectionStateState extends State<SelectionState> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        // width: 102,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: widget.isClicked ? Color(0xFF0E2522) :  const Color(0xFFFFFFFF),
          border: Border.all(
            color: widget.isClicked ? Color(0xFF0E2522) :  Color(0xFF0E2522), // Black,
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 2),
              color: widget.isClicked ? Color(0xFF0E2522) : Color(0xFF0E2522), // Black
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.isClicked ? Color(0xFFFFFFFF) : Color(0xFF0E2522), // Black
              fontFamily: "Montserrat",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.12,
            ),
          ),
        ),
      ),
    );
  }
}
