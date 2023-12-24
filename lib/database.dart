import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'items';

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Se o banco de dados não existir, inicialize-o
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE $tableName(
          id INTEGER PRIMARY KEY,
          name TEXT
        )
      ''');
    });
  }

  Future<void> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert(tableName, item);
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query(tableName);
  }
}
