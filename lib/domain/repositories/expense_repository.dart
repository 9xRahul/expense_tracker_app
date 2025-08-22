import '../entities/expense_entry.dart';

abstract class ExpenseRepository {
  Future<int> addExpense(ExpenseEntry entry);
  Future<List<ExpenseEntry>> getExpenses({required DateTime month});
  Future<double> sumByCategoryMonth(String category, DateTime month);
  
  Future<List<ExpenseEntry>> search({
    String? description,
    String? category,
    DateTime? from,
    DateTime? to,
    bool ascending = false,
  });
}
