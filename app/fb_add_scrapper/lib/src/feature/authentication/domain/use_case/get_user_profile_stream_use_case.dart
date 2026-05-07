import 'package:fb_add_scrapper/src/feature/authentication/domain/domain.dart';

class GetUserProfileStreamUseCase {
  GetUserProfileStreamUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Stream<UserProfileEntity?> call() => _authRepository.authStateChanges;
}
