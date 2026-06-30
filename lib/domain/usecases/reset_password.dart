import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase extends UseCase<void, String> {
  ResetPasswordUseCase(this._repo);
  final AuthRepository _repo;

  @override
  Future<Result<void, Failure>> call(String email) {
    if (email.trim().isEmpty) {
      return Future.value(
        const Error(ValidationFailure(message: 'Please enter your email')),
      );
    }
    return _repo.sendPasswordReset(email: email.trim());
  }
}
