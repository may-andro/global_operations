import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:use_case/use_case.dart';

class LoginFailure extends BasicFailure {
  const LoginFailure({super.message, super.cause});
}

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class LoginUseCase extends BaseUseCase<String, LoginParams, LoginFailure> {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<LoginFailure, String>> execute(LoginParams input) async {
    try {
      final userId = await _authRepository.login(
        email: input.email,
        password: input.password,
      );
      return Right(userId);
    } catch (e) {
      return Left(LoginFailure(message: e.toString(), cause: e));
    }
  }

  @override
  LoginFailure mapErrorToFailure(Object e, StackTrace st) {
    return LoginFailure(message: e.toString(), cause: e);
  }
}
