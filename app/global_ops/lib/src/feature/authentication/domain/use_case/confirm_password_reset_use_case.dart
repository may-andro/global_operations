import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:use_case/use_case.dart';

class ConfirmPasswordResetFailure extends BasicFailure {
  const ConfirmPasswordResetFailure({super.message, super.cause});
}

class ConfirmPasswordResetParams extends Equatable {
  const ConfirmPasswordResetParams({
    required this.code,
    required this.newPassword,
  });

  final String code;
  final String newPassword;

  @override
  List<Object?> get props => [code, newPassword];
}

class ConfirmPasswordResetUseCase
    extends
        BaseUseCase<
          void,
          ConfirmPasswordResetParams,
          ConfirmPasswordResetFailure
        > {
  ConfirmPasswordResetUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Either<ConfirmPasswordResetFailure, void>> execute(
    ConfirmPasswordResetParams input,
  ) async {
    await _userRepository.confirmPasswordReset(
      code: input.code,
      newPassword: input.newPassword,
    );
    return const Right(null);
  }

  @override
  ConfirmPasswordResetFailure mapErrorToFailure(Object e, StackTrace st) {
    return ConfirmPasswordResetFailure(message: e.toString(), cause: e);
  }
}
