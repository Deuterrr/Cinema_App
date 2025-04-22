import 'package:flutter/material.dart';
import 'package:cinema_application/components/custom_appbar.dart';

class MyTransactionPage extends StatefulWidget {
  const MyTransactionPage({super.key});

  @override
  State<MyTransactionPage> createState() => _MyTransactionPageState();
}

class _MyTransactionPageState extends State<MyTransactionPage> {
  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    // backgroundColor: const Color(0xFFFFFFFF), // White
    backgroundColor: Color(0xFFf0f3f8), // Flat White
    appBar: CustomAppBar(
      centerText: 'Transaction',
      showBackButton: false
    ),
    body: const Center(
      child: Text("Transaction Pages"),
    ),
  );
}
}