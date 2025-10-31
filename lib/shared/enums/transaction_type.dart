enum TransactionType {
  income('Income', '💰'),
  expense('Expense', '💸');

  final String name;
  final String emoji;

  const TransactionType(this.name, this.emoji);
}