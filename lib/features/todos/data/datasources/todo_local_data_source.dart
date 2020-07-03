import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/core/errors/exceptions.dart';
import 'package:todo_list_app/features/todos/data/models/todo_model.dart';

import 'database_helper.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getCachedTodos();
  Future<void> cacheListOfTodos(List<TodoModel> todos);
  Future<void> clearCachedTodos();
  Future<void> insertNewTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(TodoModel todo);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  @override
  Future<List<TodoModel>> getCachedTodos() async {
    try {
      List<Map> todosResult = await db.query(
        DatabaseHelper.TODOS_TABLE_NAME,
        orderBy: DatabaseHelper.DATE_COLUMN,
      );

      List<TodoModel> todos = [];

      print('kmkmk');

      for (Map todoMap in todosResult) {
        Map<String, dynamic> temp = {
          'id': todoMap['id'],
          'title': todoMap['title'],
          'body': todoMap['body'],
          'isDone': todoMap['isDone'] == 1 ? true : false,
          'date': todoMap['date'],
        };

        print(temp);
        todos.add(TodoModel.fromJson(temp));
      }

      //print('Cashed TODOS: $todos');

      return todos;
    } catch (error) {
      throw CasheException(message: error.toString());
    }
  }

  @override
  Future<void> cacheListOfTodos(List<TodoModel> todos) async {
    try {
      // await clearCachedTodos();
      final todosJson = todos.map((e) => e.toMap()).toList();
      for (Map todoMap in todosJson) {
        todoMap['isDone'] = todoMap['isDone'] ? 1 : 0;
        db.insert(
          DatabaseHelper.TODOS_TABLE_NAME,
          todoMap,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      print('TODOs cashed');
    } catch (error) {
      throw CasheException(message: error.toString());
    }
  }

  @override
  Future<void> clearCachedTodos() async {
    try {
      await db.delete(DatabaseHelper.TODOS_TABLE_NAME);
      //db.execute('DROP TABLE IF EXISTS ${DatabaseHelper.TODOS_TABLE_NAME};');
    } catch (error) {
      throw CasheException(message: error.toString());
    }
  }

  @override
  Future<void> deleteTodo(TodoModel todo) async {
    try {
      db.delete(
        DatabaseHelper.TODOS_TABLE_NAME,
        where: 'ID = ?',
        whereArgs: [todo.id],
      );
    } catch (error) {
      throw CasheException(message: error.toString());
    }
  }

  @override
  Future<void> insertNewTodo(TodoModel todo) async {
    final todoMap = todo.toMap();
    todoMap['isDone'] = todoMap['isDone'] ? 1 : 0;
    try {
      db.insert(
        DatabaseHelper.TODOS_TABLE_NAME,
        todoMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (err) {
      throw CasheException(message: err.toString());
    }
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    final todoMap = todo.toMap();
    todoMap['isDone'] = todoMap['isDone'] ? 1 : 0;
    try {
      db.update(
        DatabaseHelper.TODOS_TABLE_NAME,
        todoMap,
        where: 'ID = ?',
        whereArgs: [todo.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (err) {
      throw CasheException(message: err.toString());
    }
  }
}
