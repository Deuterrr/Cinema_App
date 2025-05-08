import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionWithIcon extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final bool haveIcon;

  const SectionWithIcon({
    required this.title,
    required this.value,
    this.icon = "",
    super.key,
    required this.haveIcon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 96,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF), // White
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (haveIcon == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 4, right: 8),
            child: SvgPicture.asset(
              icon,
              width: 30,
              height: 28,
              fit: BoxFit.contain,
            ),
          )
          else
            const SizedBox(
              width: 46, 
              height: 36,
            ),
          SizedBox(
            height: 4,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  letterSpacing: 0.12,
                  color: Colors.black,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 0.12,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
