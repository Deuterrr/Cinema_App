import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool usingText;
  final String? theText;
  final Color color;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.usingText,
    this.theText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (!usingText) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: const Color(0xFF0E2522), // Black
            width: 1,
          ),
          borderRadius: BorderRadius.circular(38),
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 1.3),
              color: Color(0xFF0E2522).withOpacity(1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Keep container color
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            padding: EdgeInsets.zero, // Make sure button fits in container
          ),
          child: Icon(
            icon,
            color: const Color(0xFF0E2522), // Black
            size: 19,
          ),
        ),
      );
    } else {
      return Container(
        height: 36,
        padding: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFFEC958), // Orange
          border: Border.all(
            color: const Color(0xFF0E2522), // Black
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(38),
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 1.3),
              color: Color(0xFF0E2522).withOpacity(1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF0E2522), // Black
                size: 22,
              ),
              if (theText?.isNotEmpty == true) ...[
                SizedBox(width: 8),
                Text(
                  theText!,
                  style: TextStyle(
                    color: Color(0xFF0E2522), // Black
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]
            ],
          ),
        ),
      );
    }
  }
}
