import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'bill.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'bill_reminder.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE bills(id TEXT PRIMARY KEY, description TEXT, amount REAL, dueDate TEXT, reminderDuration INTEGER, isPaid INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertBill(Bill bill) async {
    final db = await database;
    await db.insert('bills', bill.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Bill>> getBills() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bills');

    return List.generate(maps.length, (i) {
      return Bill.fromMap(maps[i]);
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
