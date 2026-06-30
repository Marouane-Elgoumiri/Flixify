import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/entities/auth_user.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';

class SignInParams {
  const SignInParams({required this.email, required this.password});
  final String email;
  final String password;
}

class SignInUseCase extends UseCase<AuthUser, SignInParams> {
  SignInUseCase(this._repo);
  final AuthRepository _repo;

  @override
  Future<Result<AuthUser, Failure>> call(SignInParams params) {
    if (params.email.trim().isEmpty || params.password.isEmpty) {
      return Future.value(
        const Error(ValidationFailure(message: 'Email and password are required')),
      );
    }
    return _repo.signIn(email: params.email.trim(), password: params.password);
  }
}

class ValidationFailure extends Failure {
  const ValidationFailure({String message = 'Invalid input'}) : super(message);
}
