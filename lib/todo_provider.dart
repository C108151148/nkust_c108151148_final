import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'todo.dart';

class TodoProvider {
  static const _databaseName = 'todo_database.db';
  static const _databaseVersion = 1;
  static const table = 'todo_table';

  static const columnId = 'ID';
  static const columnTitle = 'Title';
  static const columnChecked = 'checked';

  TodoProvider._privateConstructor();
  static final TodoProvider instance = TodoProvider._privateConstructor();
  Future<Database> get database async {
    Database database = await _initDatabase();
    return database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnChecked BOOLEAN NOT NULL
          )
          ''');
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await instance.database;
    return await db.insert(table, todo.toMap());
  }

  Future<List<Todo>> getTodos() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i][columnId],
        title: maps[i][columnTitle],
        checked: maps[i][columnChecked],
      );
    });
  }

  Future<int> deleteTodo(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = await instance.database;
    return await db.update(
      table,
      todo.toMap(),
      where: '$columnId = ?',
      whereArgs: [todo.id],
    );
  }
}
