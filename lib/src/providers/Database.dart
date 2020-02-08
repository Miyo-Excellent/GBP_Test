import 'dart:async';
import 'dart:io';

import 'package:gbp_test/src/models/Task.dart';
import 'package:gbp_test/src/models/User.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database _database;

  static final DatabaseProvider db = DatabaseProvider._();

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB();

    return _database;
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, "DBP_db.db");

    return await openDatabase(path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database _db, int version) async =>
            await _createTasksTable(_db));
  }

  Future _createTasksTable(Database _db) async {
    await _db.execute('CREATE TABLE Tasks ('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' user_id INTEGER,'
        ' message TEXT NOT NULL,'
        ' completed INTEGER,'
        ' date TEXT NOT NULL'
        ')');
  }

  //  CREATE Register Json
  Future<int> createTask(TaskModel task) async {
    final db = await database;

    final int result = await db.insert("Tasks", task.toMap());

    return result;
  }

  //  SELECT ─ Get A Task
  Future<TaskModel> getTask(String id) async {
    final db = await database;

    final response = await db.query("Tasks");

    if (response.isEmpty) return null;

    final Map<String, dynamic> task = response.first;

    return TaskModel.fromJsonMap(json: task);
  }

  //  SELECT ─ Get All Tasks
  Future<TasksModel> getTasks() async {
    final db = await database;

    final response = await db.query("Tasks");

    if (response.isEmpty) return TasksModel.fromJsonList(jsonList: []);

    final tasks = TasksModel.fromJsonList(jsonList: response.toList());

    return tasks;
  }

  //  SELECT ─ Get All Pending Tasks
  Future<TasksModel> getPendingTasks(UserModel user) async {
    final db = await database;

    final response =
        await db.query("Tasks", where: "user_id = ?", whereArgs: [user.id]);

    if (response.isEmpty) return TasksModel.fromJsonList(jsonList: []);

    final List pendingTasks =
        response.where((Map task) => task["completed"] == 0).toList();

    final tasks = TasksModel.fromJsonList(jsonList: pendingTasks);

    return tasks;
  }

  //  SELECT ─ Get All Completed Tasks
  Future<TasksModel> getCompletedTasks(UserModel user) async {
    final db = await database;

    final response =
        await db.query("Tasks", where: '"user_id" = ?', whereArgs: [user.id]);

    if (response.isEmpty) return TasksModel.fromJsonList(jsonList: []);

    final List pendingTasks =
        response.where((Map task) => task["completed"] == 1).toList();

    final tasks = TasksModel.fromJsonList(jsonList: pendingTasks);

    return tasks;
  }

  //  UPDATE ─ Task
  Future<int> updateTask(TaskModel task) async {
    final db = await database;

    final int result = await db
        .update("Tasks", task.toMap(), where: 'id = ?', whereArgs: [task.id]);

    return result;
  }

  //  DELETE ─ Task
  Future<int> deleteTask(TaskModel task) async {
    final db = await database;

    final int result =
        await db.delete("Tasks", where: 'id = ?', whereArgs: [task.id]);

    return result;
  }

  //  DELETE ─ All Tasks
  Future<int> deleteTasks() async {
    final db = await database;

    //  final int result = await db.rawDelete("DELETE FROM Tasks");
    final int result = await db.delete("Tasks");

    return result;
  }

  //  DELETE ─ All Tasks
  Future<Null> dropTasks() async {
    final db = await database;

    //  final int result = await db.rawDelete("DELETE FROM tasks");
    await db.execute("DROP TABLE Tasks");
  }
}
