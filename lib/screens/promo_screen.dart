import 'package:cinema_application/components/custom_appbar.dart';
import 'package:cinema_application/components/selection_state.dart';
import 'package:flutter/material.dart';

class MyPromosPage extends StatefulWidget {
  const MyPromosPage({super.key});

  @override
  State<MyPromosPage> createState() => _MyPromosPageState();
}

class _MyPromosPageState extends State<MyPromosPage> {
  bool isVoucherClicked = false;

  void _toggleButton() {
    setState(() {
      isVoucherClicked = !isVoucherClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFFFFFFF), // White
      backgroundColor: Color(0xFFf0f3f8), // Flat White
      appBar: CustomAppBar(
        centerText: 'My Vouchers',
        showBackButton: false
      ),
      body: Column(
        children: [

          // Selection State
          _selectionState(),

          SizedBox(height: 6),

          _sectionDebug(),

          SizedBox(height: 6),

          _sectionDebug(),
        ],
      )
    );
  }

  Widget _selectionState() {
    return Container(
      height: 190,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        border: Border(bottom: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)))
      ),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectionState(
            text: "Voucher",
            isClicked: isVoucherClicked,
            onPressed: () {
              if (!isVoucherClicked) {
                _toggleButton();
              }
            },
          ),
          SizedBox(width: 8),
          SelectionState(
            text: "Coupon",
            isClicked: !isVoucherClicked,
            onPressed: () {
              if (isVoucherClicked) {
                _toggleButton();
              }
            },
          ),
        ],
      )
    );
  }

  Widget _sectionDebug() {
    return Container(
      height: 128,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)))
      ),
    );
  }
}
