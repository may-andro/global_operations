import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/delete_account/bloc/delete_account_event.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/delete_account/bloc/delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc(this._getUserProfileUseCase, this._deleteAccountUseCase)
    : super(const DeleteAccountInitialState()) {
    on<LoadDeleteAccountEvent>(_mapLoadDeleteAccountEventToState);
    on<DeleteAccountSubmittedEvent>(_mapDeleteAccountSubmittedEventToState);
  }

  final GetUserProfileUseCase _getUserProfileUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  Future<void> _mapLoadDeleteAccountEventToState(
    LoadDeleteAccountEvent event,
    Emitter<DeleteAccountState> emit,
  ) async {
    emit(const DeleteAccountLoadingState());

    final userProfileEither = await _getUserProfileUseCase();
    userProfileEither.fold(
      (failure) {
        emit(DeleteAccountGetProfileErrorState(failure: failure));
      },
      (userProfile) {
        emit(DeleteAccountLoadedState(userProfile: userProfile));
      },
    );
  }

  Future<void> _mapDeleteAccountSubmittedEventToState(
    DeleteAccountSubmittedEvent event,
    Emitter<DeleteAccountState> emit,
  ) async {
    final currentState = state;

    // Preserve the user profile from the current state
    final userProfile = currentState.userProfile;

    emit(DeleteAccountLoadingState(userProfile: userProfile));

    final deleteAccountEither = await _deleteAccountUseCase(
      DeleteAccountParams(email: event.email, password: event.password),
    );
    deleteAccountEither.fold(
      (failure) {
        emit(
          DeleteAccountSubmissionErrorState(
            failure: failure,
            userProfile: userProfile,
          ),
        );
      },
      (_) {
        emit(DeleteAccountSuccessState(userProfile: userProfile));
      },
    );
  }
}
