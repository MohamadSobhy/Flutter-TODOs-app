import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> checkLoggedInState();
  Future<Either<Failure, User>> loginWithGoogle();
  Future<Either<Failure, User>> loginWithFaceBook();
  Future<Either<Failure, void>> logOut();
}
