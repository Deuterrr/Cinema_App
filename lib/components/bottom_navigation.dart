import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavbar extends StatefulWidget {
  final Function(int) onItemTap;
  final int selectedIndex;

  const BottomNavbar({super.key, required this.onItemTap, required this.selectedIndex});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(48, 6, 48, 8),
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
          const SizedBox(width: 28),
          buildNavIcon('assets/icon/ticket.svg', 1),
          const SizedBox(width: 28),
          buildNavIcon('assets/icon/transaction.svg', 2),
          const SizedBox(width: 28),
          buildNavIcon('assets/icon/profile.svg', 3),
        ],
      ),
    );
  }

  Widget buildNavIcon(String path, int index) {
    return GestureDetector(
      onTap: () {
        widget.onItemTap(index);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: widget.selectedIndex == index ? const Color(0xFFFFD580) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: SvgPicture.asset(
            path,
            width: 24,
            height: 24,
            colorFilter: widget.selectedIndex == index
                ? const ColorFilter.mode(Color(0xFFCD404A), BlendMode.srcIn)
                : null,
          ),
        ),
      ),
    );
  }
}