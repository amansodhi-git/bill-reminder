import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'bill.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'bills.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE bills(id TEXT PRIMARY KEY, description TEXT, amount REAL, dueDate TEXT, reminderDuration INTEGER)',
        );
      },
    );
  }

  Future<void> insertBill(Bill bill) async {
    final db = await database;
    await db.insert(
      'bills',
      bill.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Bill>> getBills() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bills');
    return List.generate(maps.length, (i) {
      return Bill(
        id: maps[i]['id'],
        description: maps[i]['description'],
        amount: maps[i]['amount'],
        dueDate: DateTime.parse(maps[i]['dueDate']),
        reminderDuration: Duration(days: maps[i]['reminderDuration']),
      );
    });
  }

  Future<void> updateBill(Bill bill) async {
    final db = await database;
    await db.update(
      'bills',
      bill.toMap(),
      where: 'id = ?',
      whereArgs: [bill.id],
    );
  }

  Future<void> deleteBill(String id) async {
    final db = await database;
    await db.delete(
      'bills',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
