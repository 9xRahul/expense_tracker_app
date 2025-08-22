import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AppDatabase {
  static const _dbName = 'expense_tracker.db';
  static const _dbVersion = 1;

  static Future<Database> open({required String dbPath}) async {
    final path = p.join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE incomes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT NOT NULL,
            description TEXT,
            amount REAL NOT NULL,
            date TEXT NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT NOT NULL,
            subCategory TEXT,
            description TEXT,
            amount REAL NOT NULL,
            date TEXT NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE category_limits(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT UNIQUE NOT NULL,
            monthlyLimit REAL NOT NULL
          );
        ''');
      },
    );
  }
}
