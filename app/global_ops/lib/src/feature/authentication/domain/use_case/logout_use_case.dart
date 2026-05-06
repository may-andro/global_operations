import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:use_case/use_case.dart';

class LogoutFailure extends BasicFailure {
  const LogoutFailure({super.message, super.cause});
}

class LogoutUseCase extends BaseNoParamUseCase<void, LogoutFailure> {
  LogoutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<LogoutFailure, void>> execute() async {
    try {
      await _authRepository.logout();
      return const Right(null);
    } catch (e) {
      return Left(LogoutFailure(message: e.toString(), cause: e));
    }
  }

  @override
  LogoutFailure mapErrorToFailure(Object e, StackTrace st) {
    return LogoutFailure(message: e.toString(), cause: e);
  }
}
