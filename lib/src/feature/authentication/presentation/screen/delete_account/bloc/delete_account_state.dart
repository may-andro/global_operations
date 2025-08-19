import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState({this.userProfile});

  final UserProfileEntity? userProfile;

  @override
  List<Object?> get props => [userProfile];
}

class DeleteAccountInitialState extends DeleteAccountState {
  const DeleteAccountInitialState({super.userProfile});
}

class DeleteAccountLoadingState extends DeleteAccountState {
  const DeleteAccountLoadingState({super.userProfile});
}

class DeleteAccountLoadedState extends DeleteAccountState {
  const DeleteAccountLoadedState({required UserProfileEntity userProfile})
    : super(userProfile: userProfile);
}

class DeleteAccountSuccessState extends DeleteAccountState {
  const DeleteAccountSuccessState({super.userProfile});
}

class DeleteAccountGetProfileErrorState extends DeleteAccountState {
  const DeleteAccountGetProfileErrorState({
    required this.failure,
    super.userProfile,
  });

  final GetUserProfileFailure failure;

  @override
  List<Object?> get props => [failure, userProfile];
}

class DeleteAccountSubmissionErrorState extends DeleteAccountState {
  const DeleteAccountSubmissionErrorState({
    required this.failure,
    super.userProfile,
  });

  final DeleteAccountFailure failure;

  @override
  List<Object?> get props => [failure, userProfile];
}
