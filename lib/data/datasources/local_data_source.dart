import 'package:sqflite/sqflite.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/expense_entry.dart';
import '../../domain/entities/income_entry.dart';
import '../../domain/entities/category_limit.dart';

class LocalDataSource {
  final Database db;
  LocalDataSource(this.db);

  Future<int> addIncome(IncomeEntry e) async {
    return db.insert('incomes', e.toJson());
  }

  Future<List<IncomeEntry>> getIncomesMonth(DateTime month) async {
    final start = DateValidators.yMd(DateTime(month.year, month.month, 1));
    final end = DateValidators.yMd(DateTime(month.year, month.month + 1, 0));
    final rows = await db.query(
      'incomes',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start, end],
      orderBy: 'date DESC',
    );
    return rows.map((e) => IncomeEntry.fromJson(e)).toList();
  }

  Future<int> addExpense(ExpenseEntry e) async {
    return db.insert('expenses', e.toJson());
  }

  Future<List<ExpenseEntry>> getExpensesMonth(DateTime month) async {
    final start = DateValidators.yMd(DateTime(month.year, month.month, 1));
    final end = DateValidators.yMd(DateTime(month.year, month.month + 1, 0));
    final rows = await db.query(
      'expenses',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start, end],
      orderBy: 'date DESC',
    );
    return rows.map((e) => ExpenseEntry.fromJson(e)).toList();
  }

  Future<double> sumByCategoryMonth(String category, DateTime month) async {
    final start = DateValidators.yMd(DateTime(month.year, month.month, 1));
    final end = DateValidators.yMd(DateTime(month.year, month.month + 1, 0));
    final rows = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE category = ? AND date BETWEEN ? AND ?',
      [category, start, end],
    );
    final v = rows.first['total'] as num?;
    return (v ?? 0).toDouble();
  }

  Future<List<ExpenseEntry>> searchExpenses({
    String? description,
    String? category,
    DateTime? from,
    DateTime? to,
    bool ascending = false,
  }) async {
    final where = <String>[];
    final args = <Object?>[];

    // Description: NULL-safe + case-insensitive
    if (description != null && description.trim().isNotEmpty) {
      where.add("(IFNULL(description, '') LIKE ? COLLATE NOCASE)");
      args.add('%${description.trim()}%');
    }

    // Category exact match (skip if empty)
    if (category != null && category.trim().isNotEmpty) {
      where.add("category = ?");
      args.add(category.trim());
    }

    // Date range: allow single-bound filters too
    if (from != null) {
      where.add("date >= ?");
      args.add(DateValidators.yMd(from)); // must be 'YYYY-MM-DD'
    }
    if (to != null) {
      where.add("date <= ?");
      args.add(DateValidators.yMd(to)); // must be 'YYYY-MM-DD'
    }

    // Stable sort: date then id
    final ord =
        "date ${ascending ? 'ASC' : 'DESC'}, id ${ascending ? 'ASC' : 'DESC'}";

    final rows = await db.query(
      'expenses',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: ord,
    );

    return rows.map((e) => ExpenseEntry.fromJson(e)).toList();
  }

  Future<void> upsertLimit(CategoryLimit limit) async {
    await db.insert(
      'category_limits',
      limit.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CategoryLimit?> getLimit(String category) async {
    final rows = await db.query(
      'category_limits',
      where: 'category = ?',
      whereArgs: [category],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return CategoryLimit.fromJson(rows.first);
  }

  Future<List<CategoryLimit>> getAllLimits() async {
    final rows = await db.query('category_limits', orderBy: 'category ASC');
    return rows.map((e) => CategoryLimit.fromJson(e)).toList();
  }
}
