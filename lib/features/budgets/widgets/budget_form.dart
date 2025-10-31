import 'package:expense_tracker/core/constants/category_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/budget_model.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/category_dropdown.dart';
import '../bloc/budgets_bloc.dart';

class BudgetForm extends StatefulWidget {
  final BudgetModel? budget;

  const BudgetForm({Key? key, this.budget}) : super(key: key);

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      _amountController.text = widget.budget!.monthlyLimit.toString();
      _selectedCategory = widget.budget!.category;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final now = DateTime.now();
      final budget = BudgetModel(
        category: _selectedCategory!,
        monthlyLimit: double.parse(_amountController.text),
        monthYear: DateTime(now.year, now.month), // Use current month
      );

      if (widget.budget == null) {
        context.read<BudgetsBloc>().add(AddBudget(budget));
      } else {
        context.read<BudgetsBloc>().add(UpdateBudget(budget));
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.budget == null ? 'Set Budget' : 'Edit Budget',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            CategoryDropdown(
              selectedCategory: _selectedCategory,
              onChanged: (Category? category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            CustomTextField(
              label: 'Monthly Budget Limit',
              hintText: '0.00',
              controller: _amountController,
              validator: Validators.validateAmount,
              keyboardType: TextInputType.number,
              suffixIcon: const Text('\$'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.budget == null ? 'Set Budget' : 'Update Budget',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}