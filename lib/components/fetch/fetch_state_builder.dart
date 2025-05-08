import 'package:cinema_application/data/helpers/fetch_status.dart';
import 'package:flutter/material.dart';

class FetchStateBuilder extends StatelessWidget {
  final double? height;
  final FetchStatus fetchStatus;
  final List<dynamic>? listOfThings;
  final Widget Function(List<dynamic>) builder;

  const FetchStateBuilder({
    super.key,
    this.height,
    required this.fetchStatus,
    required this.listOfThings,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (fetchStatus) {
      case FetchStatus.loading:
        child = const Center(child: CircularProgressIndicator());
        break;
      case FetchStatus.connectionError:
        child = const Center(
          child: Text(
            'No internet connection',
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0E2522),
            ),
          ),
        );
        break;
      case FetchStatus.empty:
        child = const Center(
          child: Text(
            'No movies available',
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0E2522),
            ),
          ),
        );
        break;
      case FetchStatus.unknownError:
        child = const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0E2522),
            ),
          ),
        );
        break;
      case FetchStatus.success:
        child = builder(listOfThings ?? []);
        break;
    }

    return SizedBox(
      height: height,
      child: child,
    );
  }
}