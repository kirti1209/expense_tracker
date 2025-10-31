import 'package:equatable/equatable.dart';
import '../../shared/enums/transaction_type.dart';
import '../constants/category_constants.dart';

class TransactionModel extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  final TransactionType type;
  final String? description;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.description,
  });

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
    TransactionType? type,
    String? description,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        date,
        category,
        type,
        description,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.name,
      'type': type.name,
      'description': description,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      category: Category.fromName(json['category']),
      type: json['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      description: json['description'],
    );
  }
}