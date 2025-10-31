import 'package:expense_tracker/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/bloc/settings_bloc.dart';
import 'features/splash/splash_page.dart';

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({Key? key}) : super(key: key);

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeApp();
  }

  Future<void> _initializeApp() async {
    await StorageService.init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: const SplashPage(),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text('Error initializing app: ${snapshot.error}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _initializationFuture = _initializeApp();
                        });
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return BlocProvider(
          create: (context) => SettingsBloc()..add(LoadSettings()),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Expense Tracker',
                theme: state.settings.isDarkMode 
                    ? AppTheme.darkTheme 
                    : AppTheme.lightTheme,
                home: const MainNavigation(),
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        );
      },
    );
  }
}