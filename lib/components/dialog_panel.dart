import 'dart:ui';

import 'package:cinema_application/components/custom_icon_button.dart';
import 'package:flutter/material.dart';

class DialogPanel extends StatelessWidget {
  final double panelHeightScale;
  final String panelHeader;
  final Widget mainContent;

  const DialogPanel({
    Key? key,
    required this.panelHeightScale,
    required this.panelHeader,
    required this.mainContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * panelHeightScale,
        width: MediaQuery.of(context).size.width * 1,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF0E2522), // Black
              width: 1.4,
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _closeButton(context),
            
            _panelTitle(panelHeader),
            SizedBox(height: 4),

            Expanded(child: mainContent),
            
            _confirmButton()
          ],
        ),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomIconButton(
          icon: Icons.close,
          onPressed: () => Navigator.of(context).pop(),
          usingText: false,
          color: Color(0xFFFEC958),
        ),
      ],
    );
  }

  Widget _panelTitle(String panelHeader) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        panelHeader,
        style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0E2522),
        ),
      ),
    );
  }

  Widget _confirmButton() {
    return Container(
      height: 40,
      width: double.infinity,
      color: Colors.cyan[300],
      child: ElevatedButton(
        onPressed: () {},
        child: Container(
          color: Colors.amber,
          child: Text("test")
        )
      ),
    );
  }
}
