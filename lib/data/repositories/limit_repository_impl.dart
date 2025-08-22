import '../../domain/entities/category_limit.dart';
import '../../domain/repositories/limit_repository.dart';
import '../datasources/local_data_source.dart';

class LimitRepositoryImpl implements LimitRepository {
  final LocalDataSource local;
  LimitRepositoryImpl(this.local);

  @override
  Future<List<CategoryLimit>> getAllLimits() => local.getAllLimits();

  @override
  Future<CategoryLimit?> getLimit(String category) => local.getLimit(category);

  @override
  Future<void> upsertLimit(CategoryLimit limit) => local.upsertLimit(limit);
}
