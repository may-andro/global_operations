import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:use_case/use_case.dart';

class VerifyResetPasswordCodeFailure extends BasicFailure {
  const VerifyResetPasswordCodeFailure({super.message, super.cause});
}

class VerifyResetPasswordCodeUseCase
    extends BaseUseCase<String, String, VerifyResetPasswordCodeFailure> {
  VerifyResetPasswordCodeUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Either<VerifyResetPasswordCodeFailure, String>> execute(
    String input,
  ) async {
    final email = await _userRepository.verifyPasswordResetCode(code: input);
    return Right(email);
  }

  @override
  VerifyResetPasswordCodeFailure mapErrorToFailure(Object e, StackTrace st) {
    return VerifyResetPasswordCodeFailure(message: e.toString(), cause: e);
  }
}
