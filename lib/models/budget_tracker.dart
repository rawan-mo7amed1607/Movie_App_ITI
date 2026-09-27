enum Type {
  spent,
  salary,
  bonus,
  share,
  transaction,
  bills,
  installments,
  rent,
  groceries,
  coffee,
  vacations,
  urgents,
  other,
}

class BudgetTracker {
  final String name;
  final double amount;
  final Type type;
  final bool isSpent;
  final String? customType;

  BudgetTracker({
    required this.name,
    required this.amount,
    required this.type,
    required this.isSpent,
    this.customType,
  });
}