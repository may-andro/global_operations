import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/update_password/bloc/update_password_event.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/update_password/bloc/update_password_state.dart';

class UpdatePasswordBloc
    extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  UpdatePasswordBloc(this._getUserProfileUseCase, this._updatePasswordUseCase)
    : super(const UpdatePasswordInitialState()) {
    on<LoadUpdatePasswordAccountEvent>(
      _mapLoadUpdatePasswordAccountEventToState,
    );
    on<UpdatePasswordRequestedEvent>(_mapUpdatePasswordRequestedEventToState);
  }

  final UpdatePasswordUseCase _updatePasswordUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;

  FutureOr<void> _mapLoadUpdatePasswordAccountEventToState(
    LoadUpdatePasswordAccountEvent event,
    Emitter<UpdatePasswordState> emit,
  ) async {
    emit(const UpdatePasswordLoadingState());

    final eitherResult = await _getUserProfileUseCase();

    eitherResult.fold(
      (failure) => emit(UpdatePasswordGetProfileErrorState(failure: failure)),
      (userProfile) {
        emit(UpdatePasswordLoadedState(userProfile: userProfile));
      },
    );
  }

  FutureOr<void> _mapUpdatePasswordRequestedEventToState(
    UpdatePasswordRequestedEvent event,
    Emitter<UpdatePasswordState> emit,
  ) async {
    final currentState = state;

    // Preserve the user profile from the current state
    final userProfile = currentState.userProfile;

    emit(UpdatePasswordLoadingState(userProfile: userProfile));

    final params = UpdatePasswordParams(
      email: event.email,
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );
    final eitherResult = await _updatePasswordUseCase(params);
    eitherResult.fold(
      (failure) {
        emit(
          UpdatePasswordErrorState(
            failure: failure,
            userProfile: state.userProfile,
          ),
        );
      },
      (success) {
        emit(UpdatePasswordSuccessState(userProfile: state.userProfile));
      },
    );
  }
}
