import 'package:cinema_application/components/custom_icon_button.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String centerText;
  final bool useAppTitle;
  final bool showBottomBorder;
  final bool showBackButton;
  final Widget? trailingButton;

  const CustomAppBar({
    super.key,
    this.centerText = '',
    this.showBackButton = true,
    this.showBottomBorder = true,
    this.useAppTitle = false,
    this.trailingButton,
  });

  @override
  Size get preferredSize => const Size.fromHeight(52.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13.4, 38, 0, 0),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        border: showBottomBorder
            ? Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                  width: 1.0,
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // Back Button or/w Title
          Row(
            children: [
              showBackButton
                  ? Row(
                      children: [
                        CustomIconButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onPressed: () => Navigator.of(context).pop(),
                            usingText: false,
                            color: const Color(0xFFFEC958), // Orange
                        ),
                        SizedBox(width: 12)
                      ],
                    )
                  : const SizedBox(width: 0),

              // Title
              Container(
                padding: const EdgeInsets.only(top: 4),
                alignment: Alignment.centerLeft,
                child: Text(
                  centerText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E2522), // Black
                  ),
                ),
              )
            ]
          ),

          // Trailing Button
          trailingButton != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: trailingButton!,
                )
              : const SizedBox(width: 56),
        ],
      ),
    );

  }
}
