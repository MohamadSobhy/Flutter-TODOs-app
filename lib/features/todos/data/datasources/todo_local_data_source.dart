import 'package:todo_list_app/features/todos/data/models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getCachedTodos();
  Future<void> cacheListOfTodos(List<TodoModel> todos);
  Future<void> clearCachedTodos();
}
