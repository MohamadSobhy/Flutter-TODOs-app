import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class AddNewToDo extends UseCase<String, Todo> {
  final TodoRepository repository;

  AddNewToDo({@required this.repository});

  @override
  Future<Either<Failure, String>> call(Todo todo) {
    return repository.addNewTodo(todo);
  }
}
