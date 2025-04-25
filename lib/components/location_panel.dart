import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:cinema_application/data/helpers/apihelper.dart';
import 'package:cinema_application/data/services/location_services.dart';

import 'package:cinema_application/components/custom_icon_button.dart';
import 'package:cinema_application/components/search_field.dart';

class LocationPanel extends StatefulWidget {
  final ValueChanged<String> onSelect;

  const LocationPanel({super.key, required this.onSelect});

  static Future<void> openLocationPanel(BuildContext context, ValueChanged<String> onSelect) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Location Panel",
      transitionDuration: Duration(milliseconds: 210),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            // Static blur background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Color(0xFFF9FAFB).withOpacity(0.3),
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
                child: LocationPanel(onSelect: onSelect)
              )
            )
          ]
        );
      }
    );
  }

  @override
  State<LocationPanel> createState() => _LocationPanelState();
}

class _LocationPanelState extends State<LocationPanel> {
  String selectedLocation = '-';

  final apiHelper = ApiHelper();
  final locationServices = LocationServices();
  final TextEditingController _controller = TextEditingController();

  bool _isEmptyText = true;
  List<dynamic>? allLocations;
  List<dynamic> filteredLocation = [];

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final query = _controller.text.toLowerCase();
      final isQueryEmpty = query.isEmpty;

      if (isQueryEmpty != _isEmptyText) {
        setState(() {
          _isEmptyText = isQueryEmpty;
        });
      }

      setState(() {
        if (!isQueryEmpty && allLocations != null) {
          filteredLocation = allLocations!.where((location) {
            return location['c_name'].toLowerCase().startsWith(query);
          }).toList();
        } else {
          filteredLocation = [];
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add a short delay before fetching
      Future.delayed(Duration(milliseconds: 400), () async {
        try {
          final locations = await apiHelper.getListofLocation();
          if (mounted) {
            setState(() {
              allLocations = locations;
            });
          }
        } catch (e) {
          debugPrint('Failed to fetch locations: $e');
        }
      });
    });
  }

  // Future<List<dynamic>> _fetchLocations() async {
  //   try {
  //     final locationRows = await apiHelper.getListofLocation();
  //     allLocations = locationRows;
  //     return locationRows;
  //   } catch (e) {
  //     throw Exception('Failed to fetch locations.');
  //   }
  // }

  Future<void> _handleLocationSelection(String location) async {
    setState(() {
      selectedLocation = location;
    });
    await locationServices.saveLocation(location);

     if (!mounted) return;        // prevents further code if widget is gone

    widget.onSelect(location);
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.76,
        width: MediaQuery.of(context).size.width * 1,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF0E2522), // Black
              width: 1.4
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Close Button
            _closeButton(),

            // Title
            _panelTitle(),
            SizedBox(height: 4),

            // SearchField
            _searchField(),
            SizedBox(height: 0),

            // Builder of Cities
            Expanded(
              child: allLocations == null
                ? Center(child: CircularProgressIndicator())
                : _buildLocationList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _closeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomIconButton(
          icon: Icons.close,
          onPressed: () => Navigator.of(context).pop(),
          usingText: false,
          color: Color(0xFFFEC958)
        ),
      ],
    );
  }

  Widget _panelTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        "Pick your location",
        style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0E2522),
        ),
      ),
    );
  }

  Widget _searchField() {
    return SearchField(
      controller: _controller,
      isEmptyText: _isEmptyText,
      suffixIcon: _isEmptyText,
      requestFocus: false,
      searchText: "Locations",
    );
  }

  Widget _buildLocationList() {
    List<dynamic> dataToShow = _isEmptyText ? allLocations! : filteredLocation;

    if (!_isEmptyText && dataToShow.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(top: 60),
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icon/not_found.svg',
              height: 90,
            ),
            const SizedBox(height: 16),
            Text(
              "Oops! We couldn't find '${_controller.text}'",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Please check your spelling or try another one.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 14),
      itemCount: dataToShow.length,
      itemBuilder: (context, index) {
        final cityName = dataToShow[index]['c_name'];
        return ListTile(
          title: Text(
            cityName,
            style: const TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0E2522),
            ),
          ),
          onTap: () => _handleLocationSelection(cityName),
        );
      },
    );
  }
}