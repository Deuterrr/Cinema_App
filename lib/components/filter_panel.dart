import 'package:flutter/material.dart';

class FilterPanel extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? selectedOption; // <-- nullable to allow no selection
  final ValueChanged<String> onOptionSelected;

  const FilterPanel({
    required this.title,
    required this.options,
    required this.onOptionSelected,
    this.selectedOption,
  });

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  late String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption; // <-- load initial value
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...widget.options.map((option) {
              final isSelected = option == _selectedOption;
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _selectedOption = option;
                  });
                },
              );
            }).toList(),

            ElevatedButton(
              onPressed: _selectedOption == null
                  ? null
                  : () => widget.onOptionSelected(_selectedOption!),
              child: const Text('Apply'),
            ),
          ],
        ),
      ],
    );
  }
}
