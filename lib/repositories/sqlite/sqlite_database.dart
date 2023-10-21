import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class SqliteDataBase {
  static Database? db;

  Future<Database> getDatabase() async {
    if (db == null) {
      return await initDataBase();
    } else {
      return db!;
    }
  }

  Map<int, String> scripts = {
    1: ''' CREATE TABLE contato (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT,
          path TEXT
        );'''
  };

  Future<Database> initDataBase() async {
    var db = openDatabase(
      path.join(await getDatabasesPath(), 'database.db'),
      version: scripts.length,
      onCreate: (Database db, int version) async {
        for (var i = 1; i <= scripts.length; i++) {
          await db.execute(scripts[i]!);
        }
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion + 1; i <= scripts.length; i++) {
          await db.execute(scripts[i]!);
        }
      },
    );
    return db;
  }
}
