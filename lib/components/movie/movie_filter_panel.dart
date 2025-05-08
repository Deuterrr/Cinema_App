import 'package:flutter/material.dart';

class MovieFilter extends StatefulWidget {
  final String selectedOption;
  final ValueChanged<String> onSelect;

  const MovieFilter({
    required this.selectedOption,
    required this.onSelect,
  });

  @override
  State<MovieFilter> createState() => _MovieFilterState();
}

class _MovieFilterState extends State<MovieFilter> {
  late String _selectedOption;
  final List<String> filterOptions = ["Latest", "A-Z", "Genre", "Review"];

  @override
  void initState() {
    super.initState;
    _selectedOption = widget.selectedOption;
  }

  /// handle user selection
  Future<void> _savedFilteredLocation(String selectedOption) async {
    widget.onSelect(selectedOption);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Expanded(child: _buildOptionList()),
          _confirmButton()
        ]
      )
    );
  }

  Widget _buildOptionList() {
    return ListView.builder(
      itemCount: filterOptions.length,
      itemBuilder: (context, index) {
        final option = filterOptions[index];
        final isSelected = option == _selectedOption;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: const Color(0xFFCD404A).withOpacity(0.2), // Lighter version of 0xFFCD404A
            onTap: () {
              setState(() => _selectedOption = option);
            },
            child: Column(
              children: [
                ListTile(
                  minTileHeight: 64,
                  title: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFCD404A) : Colors.black,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Color(0xFFCD404A))
                      : null,
                ),
                _horizontalDivider()
              ]
            )
          ),
        );
      }
    );
  }

  Widget _horizontalDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _confirmButton() {
    return Container(
      height: 76,
      // color: Colors.blue,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
      margin: const EdgeInsets.only(bottom: 12),
      child:
      Container(
        width: double.infinity,
        height: 22,
        decoration: BoxDecoration(
          color: const Color(0xFFCD404A), // Orange
          border: Border.all(
            color: const Color(0xFF0E2522), // Black
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 1.3),
              color: Color(0xFF0E2522).withOpacity(1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            _savedFilteredLocation(_selectedOption);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Apply",
            style: TextStyle(
              // color: Color(0xFF0E2522), // Black
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      )
    );
    // Container(
    //   // height: 40,
    //   width: double.infinity,
    //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
    //   color: Colors.cyan[300],
    //   child: ElevatedButton(
    //     onPressed: () {
    //       _savedFilteredLocation(_selectedOption);
    //       Navigator.of(context).pop();
    //     },
    //     child: Container(
    //       color: Colors.amber,
    //       child: Text("test")
    //     )
    //   ),
    // );
  }
}
