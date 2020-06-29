import 'package:todo_list_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CheckLoggedInState extends UseCase<User, NoParam> {
  final AuthRepository repository;

  CheckLoggedInState({@required this.repository});

  @override
  Future<Either<Failure, User>> call(NoParam param) {
    return repository.checkLoggedInState();
  }
}
