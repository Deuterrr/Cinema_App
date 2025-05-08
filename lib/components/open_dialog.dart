import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cinema_application/components/dialog_panel.dart';

Future<void> openDialog(BuildContext context, double panelHeightScale, String panelHeader, Widget mainContent) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final panelHeight = screenHeight * panelHeightScale;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(), // dismiss on tap outside
        child: DraggableScrollableSheet(
          initialChildSize: panelHeightScale,
          maxChildSize: panelHeightScale,
          snap: true,
          builder: (context, scrollController) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: panelHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
                child: DialogPanel(
                  panelHeightScale: panelHeightScale, 
                  panelHeader: panelHeader, 
                  mainContent: mainContent,
                ),
            );
          },
        ),
      );
    },
  );
}