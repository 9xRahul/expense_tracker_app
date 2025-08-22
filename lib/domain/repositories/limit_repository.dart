import '../entities/category_limit.dart';

abstract class LimitRepository {
  Future<void> upsertLimit(CategoryLimit limit);
  Future<CategoryLimit?> getLimit(String category);
  Future<List<CategoryLimit>> getAllLimits();
}
