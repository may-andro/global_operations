import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:use_case/use_case.dart';

class ResetPasswordRequestFailure extends BasicFailure {
  const ResetPasswordRequestFailure({super.message, super.cause});
}

class ResetPasswordRequestUseCase
    extends BaseUseCase<void, String, ResetPasswordRequestFailure> {
  ResetPasswordRequestUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Either<ResetPasswordRequestFailure, void>> execute(
    String input,
  ) async {
    await _userRepository.resetPassword(email: input);
    return const Right(null);
  }

  @override
  ResetPasswordRequestFailure mapErrorToFailure(Object e, StackTrace st) {
    return ResetPasswordRequestFailure(message: e.toString(), cause: e);
  }
}
