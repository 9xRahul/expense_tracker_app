import '../../domain/entities/income_entry.dart';
import '../../domain/repositories/income_repository.dart';
import '../datasources/local_data_source.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final LocalDataSource local;
  IncomeRepositoryImpl(this.local);

  @override
  Future<int> addIncome(IncomeEntry entry) => local.addIncome(entry);

  @override
  Future<List<IncomeEntry>> getIncomes({required DateTime month}) =>
      local.getIncomesMonth(month);
}
