import 'dart:developer';

import 'package:root/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static final int _version = 1;

  static final String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'tasks.db';

      _db = await openDatabase(_path, version: _version, onCreate: (db, version) {
        log("creating a new one");
        return db.execute("CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER)");
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  static Future<int> insert(TaskM? task) async {
    log("insert function called");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static delete(TaskM task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    await _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }
}
