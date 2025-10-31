part of 'transactions_bloc.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  final List<TransactionModel> transactions;
  final TransactionsStatus status;
  final String? error;

  const TransactionsState({
    this.transactions = const [],
    this.status = TransactionsStatus.initial,
    this.error,
  });

  TransactionsState copyWith({
    List<TransactionModel>? transactions,
    TransactionsStatus? status,
    String? error,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [transactions, status, error];
}