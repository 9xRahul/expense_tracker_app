import '../entities/income_entry.dart';

abstract class IncomeRepository {
  Future<int> addIncome(IncomeEntry entry);
  Future<List<IncomeEntry>> getIncomes({required DateTime month});
}
