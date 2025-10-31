import 'package:expense_tracker/core/constants/category_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/enums/transaction_type.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/category_dropdown.dart';
import '../bloc/transactions_bloc.dart';

class TransactionForm extends StatefulWidget {
  final TransactionModel? transaction;

  const TransactionForm({Key? key, this.transaction}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _descriptionController.text = widget.transaction!.description ?? '';
      _selectedType = widget.transaction!.type;
      _selectedCategory = widget.transaction!.category;
      _selectedDate = widget.transaction!.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final transaction = TransactionModel(
        id: widget.transaction?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        category: _selectedCategory!,
        type: _selectedType,
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
      );

      if (widget.transaction == null) {
        context.read<TransactionsBloc>().add(AddTransaction(transaction));
      } else {
        context.read<TransactionsBloc>().add(UpdateTransaction(transaction));
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
          children: [
            // Transaction Type Segmented Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Type',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment<TransactionType>(
                      value: TransactionType.expense,
                      label: Text('Expense'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                    ButtonSegment<TransactionType>(
                      value: TransactionType.income,
                      label: Text('Income'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (Set<TransactionType> newSelection) {
                    setState(() {
                      _selectedType = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),

            // Title Field
            CustomTextField(
              label: 'Title',
              hintText: 'Enter transaction title',
              controller: _titleController,
              validator: Validators.validateTitle,
            ),

            // Amount Field
            CustomTextField(
              label: 'Amount',
              hintText: '0.00',
              controller: _amountController,
              validator: Validators.validateAmount,
              keyboardType: TextInputType.number,
              suffixIcon: const Text('\$'),
            ),

            // Category Dropdown
            CategoryDropdown(
              selectedCategory: _selectedCategory,
              onChanged: (Category? category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              isExpense: _selectedType == TransactionType.expense,
            ),

            // Date Picker
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => _selectDate(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(_selectedDate.toString().split(' ')[0]),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),

            // Description Field
            CustomTextField(
              label: 'Description (Optional)',
              hintText: 'Enter description',
              controller: _descriptionController,
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.transaction == null ? 'Add Transaction' : 'Update Transaction',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}