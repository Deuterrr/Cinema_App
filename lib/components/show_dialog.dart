import 'dart:ui';

import 'package:cinema_application/components/custom_icon_button.dart';
import 'package:flutter/material.dart';

class ShowDialog extends StatefulWidget {
  final double panelHeightScale;
  final String panelHeader;
  final Widget mainContent;
  
  ShowDialog({required this.panelHeightScale, required this.panelHeader, required this.mainContent});

  static Future<void> openShowDialog(BuildContext context, double panelHeightScale, String panelHeader, Widget mainContent) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Location Panel",
      transitionDuration: Duration(milliseconds: 210),
      transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                /// This one will mimic barrierDismissible = true
                onTap: () => Navigator.of(context).pop(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Color(0xffFFFFFF).withOpacity(0.3),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 1),
                  end: Offset(0, 0),
                ).animate(CurvedAnimation(
                  parent: anim1,
                  curve: Curves.easeOut,
                )),
                child: ShowDialog(
                  panelHeightScale: panelHeightScale,
                  panelHeader: panelHeader,
                  mainContent: mainContent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * widget.panelHeightScale,
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
            _panelTitle(widget.panelHeader),
            SizedBox(height: 4),
            Expanded(
              child: widget.mainContent
            ),
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
}
