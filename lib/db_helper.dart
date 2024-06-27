import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';

class Mydb {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE chats(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      number TEXT,
      message TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
  }

  static Future<sql.Database> db() async {
    WidgetsFlutterBinding.ensureInitialized();
    return sql.openDatabase(
      join(await sql.getDatabasesPath(), 'chats.db'),
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
      },
    );
  }

  static Future<int> createItem(String? number, String? message) async {
    final db = await Mydb.db();
    final data = {
      'number': number,
      'message': message,
    };
    final id = await db.insert('chats', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await Mydb.db();
    return db.query('chats', orderBy: 'id ASC');
  }

  static Future<void> deleteItem(int id) async {
    final db = await Mydb.db();
    db.delete('chats', where: 'id = ?', whereArgs: [id]);
  }
}
