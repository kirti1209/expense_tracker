import 'package:flutter/material.dart';
import '../../core/constants/category_constants.dart';

class CategoryDropdown extends StatelessWidget {
  final Category? selectedCategory;
  final Function(Category?) onChanged;
  final bool isExpense;

  const CategoryDropdown({
    Key? key,
    this.selectedCategory,
    required this.onChanged,
    this.isExpense = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Category>(
          value: selectedCategory,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: Category.all.map((category) {
            return DropdownMenuItem<Category>(
              value: category,
              child: Row(
                children: [
                  Text(category.emoji),
                  const SizedBox(width: 8),
                  Text(category.name),
                ],
              ),
            );
          }).toList(),
          validator: (value) {
            if (value == null) {
              return 'Please select a category';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}