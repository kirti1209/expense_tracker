import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/balance_card.dart';
import '../widgets/expense_chart.dart';
import '../widgets/recent_transactions.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DashboardBloc _dashboardBloc;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = DashboardBloc()..add(LoadDashboardData());
  }

  @override
  void dispose() {
    _dashboardBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: true,
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.status == DashboardStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == DashboardStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.error}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DashboardBloc>().add(LoadDashboardData());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(LoadDashboardData());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    BalanceCard(
                      balance: state.balance,
                      income: state.totalIncome,
                      expenses: state.totalExpenses,
                    ),
                    const SizedBox(height: 16),
                    ExpenseChart(expensesByCategory: state.expensesByCategory),
                    const SizedBox(height: 16),
                    RecentTransactions(transactions: state.recentTransactions),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}