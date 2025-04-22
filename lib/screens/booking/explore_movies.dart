import 'dart:ui';

import 'package:cinema_application/data/services/location_services.dart';
import 'package:flutter/material.dart';

import 'package:cinema_application/data/services/movie_services.dart';

import 'package:cinema_application/screens/booking/search_movie.dart';

import 'package:cinema_application/components/custom_appbar.dart';
import 'package:cinema_application/components/custom_icon_button.dart';
import 'package:cinema_application/components/location_panel.dart';
import 'package:cinema_application/components/selection_state.dart';
import 'package:cinema_application/components/movie/movie_list_builder/vertical_movie_list.dart';

class ExploreMovies extends StatefulWidget {
  final bool nowShowingIsClicked;
  final List<dynamic>? nowMovies;
  final List<dynamic>? upcomingMovies;

  const ExploreMovies({
    super.key, 
    required this.nowShowingIsClicked,
    required this.nowMovies,
    required this.upcomingMovies
  });

  @override
  State<ExploreMovies> createState() => _ExploreMoviesState();
}

class _ExploreMoviesState extends State<ExploreMovies> {
  String currentLocation = '          ';
  String totalNowPlaying = "";
  String totalUpcoming = "";
  List<dynamic>? allNowPlaying;
  List<dynamic>? allUpcoming;
  late bool nowShowingIsClicked;
  bool isLoading = true;

  final movieServices = MovieServices();
  final locationServices = LocationServices();

  @override
  void initState() {
    super.initState();

    nowShowingIsClicked = widget.nowShowingIsClicked;
    allNowPlaying = widget.nowMovies ?? [];
    allUpcoming = widget.upcomingMovies ?? [];
    totalNowPlaying = allNowPlaying!.length.toString();
    totalUpcoming = allUpcoming!.length.toString();

    _loadLocation();
    _fetchMovies();
  }

  Future<void> _loadLocation() async {
    final location = await locationServices.getLocation();
    setState(() {
      currentLocation = location;
    });
  }

  void _toggleButton() {
    setState(() {
      nowShowingIsClicked = !nowShowingIsClicked;
    });
  }

  Future<void> _fetchMovies() async {
    setState(() => isLoading = true);
    try {
      var movies = await movieServices.fetchMovies(currentLocation);
      setState(() {
        allNowPlaying = movies['nowMovies'];
        allUpcoming = movies['upcomingMovies'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      // backgroundColor: Color(0xFFf0f3f8), // Cool White

      // App Bar
      appBar: CustomAppBar(
        centerText: "Explore",
        showBottomBorder: false,
        trailingButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Location button
            CustomIconButton(
              icon: Icons.location_on_outlined,
              onPressed: () => _locationPanel(context),
              usingText: true,
              theText: currentLocation,
              color: Color(0xFFFEC958), // Orange
            ),

            SizedBox(width: 6),

            // Search button
            CustomIconButton(
              icon: Icons.search_rounded,
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
              usingText: false,
              color: const Color(0xFFF686F6), // Magenta
            )
          ],
        ),
      ),

      // body
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Top Section
          _topSection(),

          SizedBox(height: 6),

          // Movie List
          _movieList()
        ],
      ),
    );
  }

  Widget _topSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
      child: Column(
        children: [

          // Selection Part
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectionState(
                text: 'Now Playing',
                isClicked: nowShowingIsClicked,
                onPressed: () {
                  if (!nowShowingIsClicked) {
                    _toggleButton();
                  }
                },
              ),
              const SizedBox(width: 8),
              SelectionState(
                text: '  Upcoming  ',
                isClicked: !nowShowingIsClicked,
                onPressed: () {
                  if (nowShowingIsClicked) {
                    _toggleButton();
                  }
                }
              )
            ]
          ),

          SizedBox(height: 8),

          // Details and Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 1, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(1, 8, 0, 0),
                  child: nowShowingIsClicked
                      ? Text(
                          "Movies ($totalNowPlaying)",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0E2522), // Black
                          )
                        )
                      : Text(
                          "Movies ($totalUpcoming)",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0E2522), // Black
                          )
                        ),
                ),
                Row(
                  children: [
                    CustomIconButton(
                      icon: Icons.tune,
                      onPressed: () {},
                      usingText: false,
                      color: Color(0xff48E4d4), // Turqoise
                    ),

                    SizedBox(width: 6),

                    CustomIconButton(
                      icon: Icons.grid_view,
                      onPressed: () {},
                      usingText: false,
                      color: Color(0xff46E1D1), // Turqoise
                    )
                  ]
                )
              ],
            )
          )
        ],
      )
    );
  }

  Widget _movieList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          _loadLocation();
          _fetchMovies();
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : allNowPlaying == null || allUpcoming == null
              ? Center(
                  child: Text(
                    'Please ensure network is available',
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF0E2522)
                    )
                  )
                )
              : VerticalMovieList(
                  nowShowingIsClicked: nowShowingIsClicked,
                  nowMovies: allNowPlaying!,
                  upcomingMovies: allUpcoming!
                )
      )
    );
  }
  
  _locationPanel(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "BlurredDialog",
      transitionDuration: Duration(milliseconds: 210),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            // Static blur background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Color(0xFFFFFFFF).withOpacity(0.35),
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

                // The Panel
                child: LocationPanel(
                  onSelect: (selectedLocation) {
                    setState(() {
                      currentLocation = selectedLocation;
                    });
                  }
                )
              )
            )
          ]
        );
      }
    );
  }
}
