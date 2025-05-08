import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:cinema_application/data/helpers/apihelper.dart';
import 'package:cinema_application/data/services/location_services.dart';

import 'package:cinema_application/components/search_field.dart';

class LocationPanel extends StatefulWidget {
  final ValueChanged<String> onSelect;

  const LocationPanel({super.key, required this.onSelect});

  @override
  State<LocationPanel> createState() => _LocationPanelState();
}

class _LocationPanelState extends State<LocationPanel> {
  bool _showExpanded = false;
  String selectedLocation = ' ';
  String _currentLocation = ' ';

  final apiHelper = ApiHelper();
  final locationServices = LocationServices();
  final TextEditingController _controller = TextEditingController();

  bool _isEmptyText = true;
  List<dynamic>? allLocations;
  List<dynamic> filteredLocation = [];

  @override
  void initState() {
    super.initState();

    _loadSavedCurrentLocation();

    /// give delay so the dialog can appear SMOOTHLY (they dont)
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showExpanded = true);
    });

    /// search logic
    _controller.addListener(() {
      final query = _controller.text.toLowerCase();
      final isQueryEmpty = query.isEmpty;

      if (isQueryEmpty != _isEmptyText) setState(() => _isEmptyText = isQueryEmpty);

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

    /// fecth the data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final locations = await apiHelper.getListofLocation();
        if (mounted) setState(() => allLocations = locations);
      } catch (e) {
        debugPrint('Failed to fetch locations: $e');
      }
    });
  }

  Future<void> _loadSavedCurrentLocation() async {
    String location = await locationServices.getSavedLocation();
    setState(() => _currentLocation = location);
  }

  /// handle user selection
  Future<void> _handleLocationSelection(String location) async {
    setState(() => selectedLocation = location);
    await locationServices.saveLocation(location);

    if (!mounted) return;

    widget.onSelect(location);
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Search Field
          _searchField(),
          
          SizedBox(height: 0),

          // Builder of Cities
          if (_showExpanded)
            Expanded(
              child: allLocations == null
                ? Center(child: CircularProgressIndicator())
                : _buildLocationList(),
            ),
        ]
      )
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
        bool temp = _currentLocation == cityName ? true : false; // is it current location?
        return ListTile(
          title: Text(
            cityName,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: temp ? Color(0xFFCD404A) : Color(0xFF0E2522),
            ),
          ),
          onTap: () => _handleLocationSelection(cityName),
        );
      },
    );
  }
}