import 'dart:io';
import 'dart:ui';

import 'package:cinema_application/components/open_dialog.dart';
import 'package:cinema_application/components/selection_panel.dart';
import 'package:cinema_application/data/helpers/apihelper.dart';
import 'package:flutter/material.dart';

import 'package:cinema_application/data/services/location_services.dart';
import 'package:cinema_application/data/services/movie_services.dart';

import 'package:cinema_application/screens/booking/movie_details.dart';
import 'package:cinema_application/screens/booking/search_movie.dart';

import 'package:cinema_application/components/custom_appbar.dart';
import 'package:cinema_application/components/custom_icon_button.dart';
import 'package:cinema_application/components/location_panel.dart';
import 'package:cinema_application/components/movie/movie_card/horizontal_movie_card.dart';
import 'package:cinema_application/components/selection_state.dart';

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
  // List<String> _options = ['Option 1', 'Option 2'];
  String _selectedOption = 'Option 1';
  String currentLocation = '          ';
  String totalNowPlaying = "";
  String totalUpcoming = "";

  List<dynamic>? allNowPlaying;
  List<dynamic>? allUpcoming;
  late dynamic desiredMovies;
  late List<String> allLocations;

  late bool nowShowingIsClicked;
  bool nowUsingGrid = false;
  bool isLoading = true;

  final movieServices = MovieServices();
  final locationServices = LocationServices();
  final apiHelper = ApiHelper();

  @override
  void initState() {
    super.initState();

    nowShowingIsClicked = widget.nowShowingIsClicked;
    allNowPlaying = widget.nowMovies ?? [];
    allUpcoming = widget.upcomingMovies ?? [];

    desiredMovies = nowShowingIsClicked ? allNowPlaying : allUpcoming;

    totalNowPlaying = allNowPlaying!.length.toString();
    totalUpcoming = allUpcoming!.length.toString();

    _loadLocation();
    _fetchMovies();

  }

  Future<void> _loadLocation() async {
    final location = await locationServices.getLocation();
    setState(() => currentLocation = location);
    allLocations = (await apiHelper.getListofLocation()).map<String>((loc) => loc['c_name'] as String).toList();
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

  void _toggleButton() {
    setState(() {
      nowShowingIsClicked = !nowShowingIsClicked;
      desiredMovies = nowShowingIsClicked ? allNowPlaying : allUpcoming;
    });
  }

  void _gridViewButton() {
    setState(() => nowUsingGrid = !nowUsingGrid);
  }

  void _updateFromLocationPanel(selectedLocation) {
    setState(() => currentLocation = selectedLocation);
  }

  // void _updateFilter(filterMovie) {
  //   setState(() => currentOption = filterMovie);
  // }

  bool isFilePath(String path) => !(path.startsWith('http://') || path.startsWith('https://'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      appBar: CustomAppBar(
        centerText: "Explore",
        showBottomBorder: false,
        trailingButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Location button
            CustomIconButton(
              icon: Icons.location_on_outlined,
              onPressed: () => openDialog(
                context, 0.76, 
                "Pick your location", 
                LocationPanel(onSelect: _updateFromLocationPanel)
              ),
              usingText: true,
              theText: currentLocation,
              color: Color(0xFFFEC958), // Orange
            ),

            SizedBox(width: 6),

            // Search button
            CustomIconButton(
              icon: Icons.search_rounded,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              ),
              usingText: false,
              color: const Color(0xFFF686F6), // Magenta
            )
          ],
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Top Section
          _topSection(),

          SizedBox(height: 6),

          // Bottom Section
          if (nowUsingGrid)
            _listViewMovieList(desiredMovies)
          else
            _gridViewMovieList(desiredMovies)
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

                    // Filter Button
                    CustomIconButton(
                      icon: Icons.tune,
                      // onPressed: () => ShowDialog.openShowDialog(context, 0.4, "Test", _filterPanel()),
                      onPressed: () async => openDialog(
                        context,
                        0.8,
                        "Test",
                        SelectionPanel(
                          useSearchField: true,
                          // options: _options,
                          // options: (await apiHelper.getListofLocation()).map<String>((loc) => loc['c_name'] as String).toList(),
                          options: allLocations,
                          selectedOption: _selectedOption,
                          onOptionSelected: (option) => setState(() => _selectedOption = option)
                        )
                      ),
                      usingText: false,
                      color: Color(0xff48E4d4), // Turqoise
                    ),

                    SizedBox(width: 6),

                    // Grid View Button
                    CustomIconButton(
                      icon: nowUsingGrid ? Icons.format_list_bulleted : Icons.grid_view,
                      onPressed: () => _gridViewButton(),
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

  // Widget _filterPanel() {
  //   return Container(
  //     color: Colors.amber[400],
  //     child: Column(
  //       children: <Widget>[
  //         ListTile(
  //           title: const Text('Option 1'),
  //           trailing: Radio(
  //             value: options[0],
  //             groupValue: currentOption,
  //             onChanged: (value) {
  //               _updateFilter(value);
  //             },
  //           ),
  //           onTap: () {
  //             setState(() {
  //               _updateFilter(options[0]);
  //             });
  //           },
  //           splashColor: Colors.cyan[500],
  //         ),
  //         ListTile(
  //           title: const Text('Option 2'),
  //           trailing: Radio(
  //             value: options[1],
  //             groupValue: currentOption,
  //             onChanged: (value) {
  //               _updateFilter(value);
  //             },
  //           ),
  //           onTap: () {
  //             _updateFilter(options[1]);
  //           },
  //           splashColor: Colors.cyan[500],
  //         )
  //       ],
  //     ),
  //   );
  // }


  // static _showFilter(BuildContext context) {
  //   return showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: "Location Panel",
  //     transitionDuration: Duration(milliseconds: 210),
  //     transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  //       return FadeTransition(
  //         opacity: CurvedAnimation(
  //           parent: animation,
  //           curve: Curves.easeOut,
  //         ),
  //         child: child,
  //       );
  //     },
  //     pageBuilder: (context, anim1, anim2) {
  //       return Stack(
  //         children: [
  //           // Static blur background
  //           Positioned.fill(
  //             child: BackdropFilter(
  //               filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
  //               child: Container(
  //                 color: Color(0xffFFFFFF).withOpacity(0.3),
  //               ),
  //             ),
  //           ),
  //           Align(
  //             alignment: Alignment.bottomCenter,
  //             child: SlideTransition(
  //               position: Tween<Offset>(
  //                 begin: Offset(0, 1),
  //                 end: Offset(0, 0),
  //               ).animate(CurvedAnimation(
  //                 parent: anim1,
  //                 curve: Curves.easeOut,
  //               )),

  //               // The Panel
  //               child: Material(
  //                 color: Colors.transparent,
  //                 elevation: 0,
  //                 child: Container(
  //                   height: MediaQuery.of(context).size.height * 0.76,
  //                   width: MediaQuery.of(context).size.width * 1,
  //                   padding: EdgeInsets.all(16),
  //                   decoration: BoxDecoration(
  //                     color: Color(0xFFFFFFFF),
  //                     border: Border(
  //                       top: BorderSide(
  //                         color: const Color(0xFF0E2522), // Black
  //                         width: 1.4
  //                       ),
  //                     ),
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(10),
  //                       topRight: Radius.circular(10),
  //                     ),
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [

  //                       // Close Button
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.end,
  //                         children: [
  //                           CustomIconButton(
  //                             icon: Icons.close,
  //                             onPressed: () => Navigator.of(context).pop(),
  //                             usingText: false,
  //                             color: Color(0xFFFEC958)
  //                           ),
  //                         ],
  //                       ),

  //                       // Title
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(vertical: 8),
  //                         child: Text(
  //                           "Pick your location",
  //                           style: TextStyle(
  //                             fontFamily: "Montserrat",
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w600,
  //                             color: Color(0xFF0E2522),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(height: 4),

  //                       // Builder of Cities
  //                       Expanded(
  //                         child: allLocations == null
  //                           ? Center(child: CircularProgressIndicator())
  //                           : _buildLocationList(),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               )
  //             )
  //           )
  //         ]
  //       );
  //     }
  //   );
  // }

  Widget _listViewMovieList(dynamic desiredMovies) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          _loadLocation();
          _fetchMovies();
        },
        child: SizedBox(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 42),
            child: Column(
              children: List.generate(
                desiredMovies.length,
                (index) {
                  final movie = desiredMovies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Moviedetail(
                            movieTitle:         movie['m_title'],
                            movieImage:         movie['m_imageurl'],
                            movieGenre:         movie['m_genre'],
                            movieDescription:   "debug",
                            movieRating:        "debug",
                            movieYears:         "debug",
                            movieDuration:      "debug",
                            movieWatchlist:     "debug",
                          )
                        )
                      );
                    },
                    child: HorizontalMovieCard(
                      index: index,
                      movieTitle:     movie['m_title'],
                      movieImage:     movie['m_imageurl'],
                      movieGenre:     movie['m_genre'],
                      movieScore:     "debug",
                      movieDuration:  "debug",
                      movieRated:     "debug",
                    ),
                  );
                },
              ),
            ),
          ),
        )
      )
    );
  }

  Widget _gridViewMovieList(dynamic desiredMovies) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          _loadLocation();
          _fetchMovies();
        },
        child: Container(
          // margin: const EdgeInsets.only(bottom: 42),
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,             // 2 rows vertically
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 3 / 5.9,       // 3:4 aspect (width : height)
            ),
            itemCount: desiredMovies.length,
            itemBuilder: (context, index) {
              final movie = desiredMovies[index];

              //card part
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF), // White
                  // color: Colors.amber[100], // White
                  borderRadius: BorderRadius.circular(8),
                ),
                child: 
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff000000).withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: 
                        AspectRatio(
                          aspectRatio: 3 / 4.6,
                          child: isFilePath(movie['m_imageurl'])
                              ? Image.file(
                                  File(movie['m_imageurl']),
                                  fit: BoxFit.cover, // Or BoxFit.fitWidth depending on your preference
                                )
                              : Image.network(
                                  movie['m_imageurl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.movie, size: 50, color: Colors.grey),
                                    );
                                  }
                                )
                        )
                      )
                    ),

                    const SizedBox(height: 8),
                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 1),
                      // color: Colors.blue[300],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie['m_title'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 8),

                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              // Genre
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(0xff000000).withOpacity(0.08),
                                ),
                                child: Text(
                                  movie['m_genre'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              // Duration
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(0xff000000).withOpacity(0.08),
                                ),
                                child: Text(
                                  "debug",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              // Rated
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(0xff000000).withOpacity(0.08),
                                ),
                                child: Text(
                                  "debug",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                              )
                            ]
                          )
                        ]
                      )
                    )
                  ]
                )
              );
            }
          )
        )
      )
    );
  }
}
