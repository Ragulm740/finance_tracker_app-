import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'finance.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL,
            category TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<int> addTransaction(double amount, String category, String date) async {
    final dbClient = await db;
    return await dbClient.insert('transactions', {
      'amount': amount,
      'category': category,
      'date': date,
    });
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final dbClient = await db;
    return await dbClient.query('transactions');
  }

  Future<int> deleteTransaction(int id) async {
    final dbClient = await db;
    return await dbClient.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
