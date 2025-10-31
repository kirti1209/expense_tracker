import 'package:expense_tracker/core/models/budget_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/budgets_bloc.dart';
import '../widgets/budget_card.dart';
import '../widgets/budget_form.dart';
import '../../../shared/widgets/empty_state.dart';

class BudgetsPage extends StatelessWidget {
  const BudgetsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BudgetsBloc()..add(LoadBudgets()),
      child: Builder(
        builder: (blocContext) => Scaffold(
          appBar: AppBar(
            title: const Text('Budgets'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  final budgetsBloc = blocContext.read<BudgetsBloc>();
                  showModalBottomSheet(
                    context: blocContext,
                    isScrollControlled: true,
                    builder: (modalContext) {
                      return BlocProvider.value(
                        value: budgetsBloc,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                          ),
                          child: const BudgetForm(),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: BlocBuilder<BudgetsBloc, BudgetsState>(
            builder: (context, state) {
              if (state.status == BudgetsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.budgets.isEmpty) {
                return const EmptyState(
                  message: 'No budgets set',
                  subtitle: 'Set monthly budgets to track your spending',
                  icon: Icons.account_balance_wallet,
                );
              }

              return ListView.builder(
                itemCount: state.budgets.length,
                itemBuilder: (context, index) {
                  final budget = state.budgets[index];
                  final utilization = state.budgetUtilization[budget.category] ?? 0.0;

                  return BudgetCard(
                    budget: budget,
                    utilization: utilization,
                    onEdit: () {
                      final budgetsBloc = context.read<BudgetsBloc>();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (modalContext) {
                          return BlocProvider.value(
                            value: budgetsBloc,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                              ),
                              child: BudgetForm(budget: budget),
                            ),
                          );
                        },
                      );
                    },
                    onDelete: () {
                      _showDeleteBudgetDialog(context, budget);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteBudgetDialog(BuildContext context, BudgetModel budget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Budget"),
          content: Text("Are you sure you want to delete the budget for ${budget.category.name}?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final budgetsBloc = context.read<BudgetsBloc>();
                Navigator.of(context).pop();
                budgetsBloc.add(DeleteBudget(budget));
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}