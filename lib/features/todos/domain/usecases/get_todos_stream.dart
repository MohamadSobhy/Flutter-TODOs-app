import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class GetTodoStream extends UseCase<Stream<List<Todo>>, NoParam> {
  final TodoRepository repository;

  GetTodoStream({@required this.repository});

  @override
  Future<Either<Failure, Stream<List<Todo>>>> call(NoParam param) {
    return repository.getTodosStream();
  }
}
