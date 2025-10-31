import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/transactions_bloc.dart';
import '../widgets/transaction_list.dart';
import '../widgets/transaction_form.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionsBloc()..add(LoadTransactions()),
      child: Builder(
        builder: (blocContext) => Scaffold(
          appBar: AppBar(
            title: const Text('Transactions'),
            centerTitle: true,
          ),
          body: const TransactionList(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final transactionsBloc = blocContext.read<TransactionsBloc>();
              showModalBottomSheet(
                context: blocContext,
                isScrollControlled: true,
                builder: (modalContext) {
                  return BlocProvider.value(
                    value: transactionsBloc,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                      ),
                      child: const TransactionForm(),
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}