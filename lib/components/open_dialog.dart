import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cinema_application/components/dialog_panel.dart';

Future<void> openDialog(BuildContext context, double panelHeightScale, String panelHeader, Widget mainContent) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final panelHeight = screenHeight * panelHeightScale;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(), // dismiss on tap outside
        child: Stack(
          children: [

            /// blur and semi-transparent background
            _blurBackground(),

            /// dialog body
            DraggableScrollableSheet(
              initialChildSize: panelHeightScale,
              maxChildSize: 0.95,
              minChildSize: 0.25,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  height: panelHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: DialogPanel(
                    panelHeightScale: panelHeightScale,
                    panelHeader: panelHeader,
                    mainContent: mainContent,
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _blurBackground() {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
    child: Container(
      color: Color(0xffFFFFFF).withOpacity(0.3),
    ),
  );
}