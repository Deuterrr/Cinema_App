import 'package:cinema_application/components/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectionPanel extends StatefulWidget {
  final bool useSearchField;
  final List<String> options;
  final String? selectedOption; // <-- nullable to allow no selection
  final ValueChanged<String> onOptionSelected;

  const SelectionPanel({
    required this.useSearchField,
    required this.options,
    required this.onOptionSelected,
    this.selectedOption,
  });

  @override
  State<SelectionPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<SelectionPanel> {
  final TextEditingController _controller = TextEditingController();

  late String? _selectedOption = widget.selectedOption;

  bool _isEmptyText = true;
  late final List<dynamic> _listOptions = widget.options;
  List<dynamic> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    // _listOptions = widget.options;

    // Search Logic
    _controller.addListener(() {
      final query = _controller.text.toLowerCase();
      final isQueryEmpty = query.isEmpty;

      if (isQueryEmpty != _isEmptyText) {
        setState(() => _isEmptyText = isQueryEmpty);
      }

      setState(() {
        if (!isQueryEmpty) {
          _filteredOptions = _listOptions.where((option) {
            return option.toLowerCase().startsWith(query);
          }).toList();
        } else {
          _filteredOptions = [];
        }
      });
    });
  }

  // Confirmation Button

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.useSearchField) _searchField(),
        const SizedBox(height: 0),

        Expanded(child: _buildOptionList())
      ],
    );
  }

  Widget _searchField() {
    return SearchField(
      controller: _controller,
      isEmptyText: _isEmptyText,
      suffixIcon: _isEmptyText,
      requestFocus: false,
      searchText: "",
    );
  }

  Widget _buildOptionList() {
    List<dynamic> dataToShow = _isEmptyText ? _listOptions : _filteredOptions;

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
      padding: const EdgeInsets.only(top: 14),
      itemCount: dataToShow.length,
      itemBuilder: (context, index) {
        final option = dataToShow[index];
        final isSelected = option == _selectedOption;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: ListTile(
            title: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade900 : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: Colors.blue)
                : null,
            onTap: () {
              setState(() {
                _selectedOption = option;
              });
            },
          ),
        );
      },
    );
  }
}
