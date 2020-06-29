import '../../../../core/errors/failures.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class LogOut extends UseCase<void, NoParam> {
  final AuthRepository repository;

  LogOut({@required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParam param) {
    return repository.logOut();
  }
}
