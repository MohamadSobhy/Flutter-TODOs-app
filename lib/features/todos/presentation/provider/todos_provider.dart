import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:todo_list_app/core/errors/failures.dart';
import 'package:todo_list_app/core/usecase/usecase.dart';
import 'package:todo_list_app/features/todos/domain/usecases/add_new_todo.dart';
import 'package:todo_list_app/features/todos/domain/usecases/delete_todo.dart';
import 'package:todo_list_app/features/todos/domain/usecases/update_todo.dart';

import '../../domain/entities/todo.dart';
import '../../domain/usecases/get_todos_stream.dart';

class TodoProvider {
  final GetTodoStream getTodoStream;
  final AddNewToDo addNewToDo;
  final UpdateToDo updateToDo;
  final DeleteToDo deleteToDo;

  TodoProvider({
    @required this.getTodoStream,
    @required this.addNewToDo,
    @required this.updateToDo,
    @required this.deleteToDo,
  });

  Future<Either<Failure, Stream<List<Todo>>>> getTodosStream() async {
    final todoStreamEither = await getTodoStream(NoParam());
    return todoStreamEither;
    // return todoStreamEither.fold(
    //   (failure) {
    //     print('failed');//Todo
    //     return Stream.empty();
    //   },
    //   (todosStream) {
    //     print(todosStream);
    //     return todosStream;
    //   },
    // );
  }

  Future<String> addNewTodo(Todo todo) async {
    return await _manageTodoEitherHandler(addNewToDo(todo));
  }

  Future<String> updateTodo(Todo todo) async {
    return await _manageTodoEitherHandler(updateToDo(todo));
  }

  Future<String> deleteTodo(Todo todo) async {
    return await _manageTodoEitherHandler(deleteToDo(todo));
  }

  Future<String> _manageTodoEitherHandler(manageTodoEither) async {
    final addTodoEither = await manageTodoEither;

    return addTodoEither.fold(
      (failure) => failure.message,
      (successMsg) => successMsg,
    );
  }
}
