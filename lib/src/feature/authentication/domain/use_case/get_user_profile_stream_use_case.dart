import 'package:global_ops/src/feature/authentication/domain/domain.dart';

class GetUserProfileStreamUseCase {
  GetUserProfileStreamUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Stream<UserProfileEntity?> call() => _authRepository.authStateChanges;
}
