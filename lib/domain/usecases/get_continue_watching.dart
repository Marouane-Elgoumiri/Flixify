import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/entities/progress_entity.dart';
import 'package:my_app/domain/repositories/user_data_repository.dart';

/// Use case: Get all progress rows for the current user.
///
/// Section 6 ties this to the "Continue Watching" row on the Home screen.
class GetContinueWatchingUseCase
    extends UseCase<List<ProgressEntity>, NoParams> {
  GetContinueWatchingUseCase({required UserDataRepository repository})
      : _repository = repository;

  final UserDataRepository _repository;

  @override
  Future<Result<List<ProgressEntity>, Failure>> call(NoParams params) async {
    try {
      final rows = await _repository.getAllProgress();
      return Success(rows);
    } catch (e) {
      return Error(ServerFailure(message: 'Failed to load progress: $e'));
    }
  }
}

