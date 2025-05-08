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
        padding: EdgeInsets.only(top: 16),
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
            Container(
              padding: const EdgeInsets.fromLTRB(16, 6, 16,  0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _panelTitle(panelHeader),
                  _closeButton(context)
                ],
              ),
            ),

            SizedBox(height: 12),

            Expanded(child: mainContent),
          ],
        ),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: CustomIconButton(
        icon: Icons.close,
        onPressed: () => Navigator.of(context).pop(),
        usingText: false,
        color: Color(0xFFFEC958),
      )
    );
  }

  Widget _panelTitle(String panelHeader) {
    return Padding(
      padding: const EdgeInsets.only(left: 1),
      child: Text(
        panelHeader,
        style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0E2522),
        ),
      ),
    );
  }
}
