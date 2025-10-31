import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/services/storage_service.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc() : super(const TransactionsState()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(status: TransactionsStatus.loading));
    
    try {
      final transactions = await StorageService.getTransactions();
      emit(state.copyWith(
        transactions: transactions,
        status: TransactionsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TransactionsStatus.failure,
        error: 'Failed to load transactions: $e',
      ));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      await StorageService.saveTransaction(event.transaction);
      final transactions = await StorageService.getTransactions();
      emit(state.copyWith(
        transactions: transactions,
        status: TransactionsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TransactionsStatus.failure,
        error: 'Failed to add transaction: $e',
      ));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      await StorageService.updateTransaction(event.transaction);
      final transactions = await StorageService.getTransactions();
      emit(state.copyWith(
        transactions: transactions,
        status: TransactionsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TransactionsStatus.failure,
        error: 'Failed to update transaction: $e',
      ));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      await StorageService.deleteTransaction(event.transactionId);
      final transactions = await StorageService.getTransactions();
      emit(state.copyWith(
        transactions: transactions,
        status: TransactionsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TransactionsStatus.failure,
        error: 'Failed to delete transaction: $e',
      ));
    }
  }
}