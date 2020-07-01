import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/todo.dart';

abstract class TodoRepository {
  Future<Either<Failure, Stream<List<Todo>>>> getTodosStream();
  Future<Either<Failure, String>> addNewTodo(Todo todo);
  Future<Either<Failure, String>> updateTodo(Todo todo);
  Future<Either<Failure, String>> deleteTodo(Todo todo);
  Future<Either<Failure, void>> clearCashedTodos();
}
