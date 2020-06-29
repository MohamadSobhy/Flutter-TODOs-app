import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginWithFacebook extends UseCase<User, NoParam> {
  final AuthRepository repository;

  LoginWithFacebook({@required this.repository});

  @override
  Future<Either<Failure, User>> call(NoParam param) {
    return repository.loginWithFaceBook();
  }
}
