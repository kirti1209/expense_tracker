part of 'transactions_bloc.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionsEvent {
  const LoadTransactions();
}

class AddTransaction extends TransactionsEvent {
  final TransactionModel transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class UpdateTransaction extends TransactionsEvent {
  final TransactionModel transaction;

  const UpdateTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteTransaction extends TransactionsEvent {
  final String transactionId;

  const DeleteTransaction(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}