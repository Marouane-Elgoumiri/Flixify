import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/entities/auth_user.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';

class SignUpParams {
  const SignUpParams({
    required this.email,
    required this.password,
    this.displayName,
  });
  final String email;
  final String password;
  final String? displayName;
}

class SignUpUseCase extends UseCase<AuthUser, SignUpParams> {
  SignUpUseCase(this._repo);
  final AuthRepository _repo;

  @override
  Future<Result<AuthUser, Failure>> call(SignUpParams params) async {
    final email = params.email.trim();
    final pass = params.password;

    if (email.isEmpty || pass.isEmpty) {
      return const Error(
        ValidationFailure(message: 'Email and password are required'),
      );
    }
    if (pass.length < 6) {
      return const Error(
        ValidationFailure(message: 'Password must be at least 6 characters'),
      );
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(email)) {
      return const Error(
        ValidationFailure(message: 'Please enter a valid email'),
      );
    }
    return _repo.signUp(
      email: email,
      password: pass,
      displayName: params.displayName,
    );
  }
}
