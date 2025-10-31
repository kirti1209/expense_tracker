import 'package:flutter/material.dart';
import 'features/dashboard/pages/dashboard_page.dart';
import 'features/transactions/pages/transactions_page.dart';
import 'features/budgets/pages/budgets_page.dart';
import 'features/settings/pages/settings_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  int _dashboardKey = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardPage(key: ValueKey(_dashboardKey)),
          const TransactionsPage(),
          const BudgetsPage(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            // If switching to dashboard, recreate it to refresh data
            if (index == 0 && _currentIndex != 0) {
              setState(() {
                _dashboardKey++;
                _currentIndex = index;
              });
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: IconThemeData(size: 28),
          unselectedIconTheme: IconThemeData(size: 24),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded),
              activeIcon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Budgets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              activeIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}