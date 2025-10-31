# Smart Personal Finance & Expense Tracker

A cross-platform Flutter application for tracking personal expenses and budgets with basic analytics.

## Features

### Core Features

- **Dashboard**
  - Current balance display (Income – Expenses)
  - Recent transactions (last 5-10)
  - Interactive pie chart showing expenses by category
  - Responsive layout for mobile screens

- **Transactions**
  - Add, edit, and delete transactions with categories
  - 7 predefined categories: Food, Travel, Bills, Shopping, Entertainment, Healthcare, Other
  - Input validation and error handling
  - Tap on any transaction to edit
  - Swipe-to-delete with undo confirmation
  - Offline storage using SQLite

- **Budgets**
  - Set monthly budget limits per category
  - Visual progress indicators
  - Color-coded alerts when approaching budget limit
  - Over-budget highlighting with red indicators

- **Settings**
  - Dark/Light mode toggle
  - Export transactions to CSV
  - Clear all data option

## Technical Stack

- **Framework**: Flutter 3.x+
- **State Management**: BLoC (flutter_bloc ^8.1.3)
- **Local Storage**: SQLite (sqflite ^2.3.0)
- **Charts**: fl_chart ^0.68.0
- **Architecture**: Clean Architecture with feature-based modular structure

## Architecture

### Project Structure

```
lib/
├── core/
│   ├── constants/        # App-wide constants
│   ├── models/           # Data models
│   ├── services/         # Business logic services
│   │   ├── analytics_service.dart    # Financial calculations
│   │   ├── database_service.dart     # SQLite database operations
│   │   ├── export_service.dart       # CSV export functionality
│   │   └── storage_service.dart      # Data persistence layer
│   ├── theme/            # App theming (light/dark)
│   └── utils/            # Helper functions and validators
├── features/
│   ├── budgets/          # Budget management feature
│   │   ├── bloc/         # Budgets BLoC (state management)
│   │   ├── pages/        # Budgets UI pages
│   │   └── widgets/      # Budget-specific widgets
│   ├── dashboard/        # Dashboard feature
│   │   ├── bloc/         # Dashboard BLoC
│   │   ├── pages/        # Dashboard UI
│   │   └── widgets/      # Dashboard widgets (charts, cards)
│   ├── settings/         # Settings feature
│   │   ├── bloc/         # Settings BLoC
│   │   └── pages/        # Settings UI
│   ├── splash/           # Splash screen
│   └── transactions/     # Transaction management feature
│       ├── bloc/         # Transactions BLoC
│       ├── pages/        # Transactions UI
│       └── widgets/      # Transaction widgets (form, list)
├── shared/               # Shared utilities across features
│   ├── enums/            # Shared enumerations
│   └── widgets/          # Reusable widgets
├── app.dart              # Main app configuration
├── main_navigation.dart  # Bottom navigation
└── main.dart             # App entry point
```

### State Management

The app uses **BLoC (Business Logic Component)** pattern for state management:

- **TransactionsBloc**: Manages transaction CRUD operations
- **DashboardBloc**: Handles dashboard data aggregation
- **BudgetsBloc**: Manages budget CRUD and utilization calculations
- **SettingsBloc**: Controls app settings and dark mode

### Storage

**SQLite** is used for offline data persistence:

- **Tables**:
  - `transactions`: Stores all income/expense records
  - `budgets`: Stores monthly budget limits per category
  - `settings`: Stores user preferences

All database operations are abstracted through `DatabaseService` and `StorageService`.

## Setup Instructions

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd expense_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/transaction_test.dart
flutter test test/widget_test.dart
flutter test test/analytics_service_test.dart
```

### Building the App

**Android**
```bash
flutter build apk --release
```

**iOS**
```bash
flutter build ios --release
```

## Testing

### Test Coverage

- **Unit Tests**:
  - `transaction_test.dart`: Transaction model serialization, copyWith
  - `analytics_service_test.dart`: Financial calculations (balance, income, expenses, category grouping)

- **Widget Tests**:
  - `widget_test.dart`: Dashboard and Transactions page UI tests

### Current Coverage

- ✅ Transaction model tests
- ✅ Analytics service tests
- ✅ Dashboard widget tests
- ✅ Transactions widget tests

## Screenshots

*Note: Add app screenshots here showing:*
- Dashboard with charts
- Transaction list
- Budget management
- Dark mode view

## Development Notes

### Code Quality

- Follows Flutter lints and best practices
- Uses `analysis_options.yaml` for code analysis
- Clean, modular architecture
- Proper separation of concerns

### Future Enhancements

- Add more comprehensive CRUD tests for database operations
- Implement filtering and search for transactions
- Add date range picker for budget periods
- Implement data backup/restore functionality
- Add more chart types (bar charts, trend analysis)

## Author

Developed as a Flutter technical assignment demonstrating:
- Flutter widget development
- State management with BLoC
- Local storage with SQLite
- Responsive UI design
- Testing practices
- Clean architecture principles

## License

This project is created for educational purposes.
