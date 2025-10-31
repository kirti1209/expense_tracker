part of 'budgets_bloc.dart';

abstract class BudgetsEvent extends Equatable {
  const BudgetsEvent();

  @override
  List<Object> get props => [];
}

class LoadBudgets extends BudgetsEvent {
  const LoadBudgets();
}

class AddBudget extends BudgetsEvent {
  final BudgetModel budget;

  const AddBudget(this.budget);

  @override
  List<Object> get props => [budget];
}

class UpdateBudget extends BudgetsEvent {
  final BudgetModel budget;

  const UpdateBudget(this.budget);

  @override
  List<Object> get props => [budget];
}

class DeleteBudget extends BudgetsEvent {
  final BudgetModel budget;

  const DeleteBudget(this.budget);

  @override
  List<Object> get props => [budget];
}