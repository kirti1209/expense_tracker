import 'package:equatable/equatable.dart';
import '../constants/category_constants.dart';

class BudgetModel extends Equatable {
  final Category category;
  final double monthlyLimit;
  final DateTime monthYear;

  const BudgetModel({
    required this.category,
    required this.monthlyLimit,
    required this.monthYear, // Fixed parameter name
  });

  BudgetModel copyWith({
    Category? category,
    double? monthlyLimit,
    DateTime? monthYear,
  }) {
    return BudgetModel(
      category: category ?? this.category,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      monthYear: monthYear ?? this.monthYear, // Fixed this line
    );
  }

  @override
  List<Object?> get props => [category, monthlyLimit, monthYear];

  Map<String, dynamic> toJson() {
    return {
      'category': category.name,
      'monthly_limit': monthlyLimit,
      'month_year': monthYear.toIso8601String(),
    };
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      category: Category.fromName(json['category']),
      monthlyLimit: (json['monthly_limit'] as num).toDouble(),
      monthYear: DateTime.parse(json['month_year']),
    );
  }
}