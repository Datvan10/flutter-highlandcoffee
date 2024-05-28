import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class CategoryDropdown extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final void Function(String?)? onChanged;

  const CategoryDropdown({
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 10),
            child: Text(
              'Danh mục',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Tooltip(
                      message: category,
                        child: Container(
                          width: 120,
                          child: Text(
                                                category,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                        )),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
