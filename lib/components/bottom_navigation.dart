import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTap;

  const BottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(48, 6, 48, 30),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // White
        border: Border(
          top: BorderSide(
            color: const Color(0xFF0E2522).withOpacity(0.1), // Faint black
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildNavIcon('assets/icon/home.svg', 0),
          const SizedBox(width: 36),
          buildNavIcon('assets/icon/ticket.svg', 1),
          const SizedBox(width: 36),
          buildNavIcon('assets/icon/transaction.svg', 2),
          const SizedBox(width: 36),
          buildNavIcon('assets/icon/profile.svg', 3),
        ],
      ),
    );
  }

  Widget buildNavIcon(String path, int index) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTap(index),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFD580) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: SvgPicture.asset(
            path,
            width: 24,
            height: 24,
            colorFilter: isSelected
                ? const ColorFilter.mode(Color(0xFFCD404A), BlendMode.srcIn)
                : null,
          ),
        ),
      ),
    );
  }
}
