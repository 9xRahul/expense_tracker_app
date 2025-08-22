import '../../domain/entities/expense_entry.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/local_data_source.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  
  final LocalDataSource local;
  ExpenseRepositoryImpl(this.local);

  @override
  Future<int> addExpense(ExpenseEntry entry) => local.addExpense(entry);

  @override
  Future<List<ExpenseEntry>> getExpenses({required DateTime month}) =>
      local.getExpensesMonth(month);

  @override
  Future<double> sumByCategoryMonth(String category, DateTime month) =>
      local.sumByCategoryMonth(category, month);

  @override
  Future<List<ExpenseEntry>> search({
    String? description,
    String? category,
    DateTime? from,
    DateTime? to,
    bool ascending = false,
  }) => local.searchExpenses(
    description: description,
    category: category,
    from: from,
    to: to,
    ascending: ascending,
  );
}
