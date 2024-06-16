import 'package:flutter/material.dart';

/// Dropdown widget for selecting news categories.
class CategoryDropdown extends StatelessWidget {
  final String selectedCategory; // Currently selected category.
  final ValueChanged<String?> onChanged; // Callback function when category changes.

  CategoryDropdown({super.key, required this.selectedCategory, required this.onChanged});

  // List of available news categories.
  final List<String> _categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: [
          // Filter search text label with gray italic style.
          const Text(
            'Filter search   ',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),

          // Container holding the dropdown button.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCategory, // Currently selected category.
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                dropdownColor: Colors.white,
                onChanged: onChanged, // Callback when category changes.
                items: _categories.map((String category) {
                  // Mapping categories to DropdownMenuItem widgets.
                  return DropdownMenuItem<String>(
                    value: category,
                    child:
                        Text(category[0].toUpperCase() + category.substring(1)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
