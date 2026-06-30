import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';

class SignOutUseCase extends UseCase<void, NoParams> {
  SignOutUseCase(this._repo);
  final AuthRepository _repo;

  @override
  Future<Result<void, Failure>> call(NoParams params) => _repo.signOut();
}
