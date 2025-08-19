import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';

abstract class UpdatePasswordState extends Equatable {
  const UpdatePasswordState({this.userProfile});

  final UserProfileEntity? userProfile;

  @override
  List<Object?> get props => [userProfile];
}

class UpdatePasswordInitialState extends UpdatePasswordState {
  const UpdatePasswordInitialState({super.userProfile});
}

class UpdatePasswordLoadingState extends UpdatePasswordState {
  const UpdatePasswordLoadingState({super.userProfile});
}

class UpdatePasswordLoadedState extends UpdatePasswordState {
  const UpdatePasswordLoadedState({required UserProfileEntity userProfile})
    : super(userProfile: userProfile);
}

class UpdatePasswordSuccessState extends UpdatePasswordState {
  const UpdatePasswordSuccessState({super.userProfile});
}

class UpdatePasswordGetProfileErrorState extends UpdatePasswordState {
  const UpdatePasswordGetProfileErrorState({
    required this.failure,
    super.userProfile,
  });

  final GetUserProfileFailure failure;

  @override
  List<Object?> get props => [failure, userProfile];
}

class UpdatePasswordErrorState extends UpdatePasswordState {
  const UpdatePasswordErrorState({required this.failure, super.userProfile});

  final UpdatePasswordFailure failure;

  @override
  List<Object?> get props => [failure, userProfile];
}
