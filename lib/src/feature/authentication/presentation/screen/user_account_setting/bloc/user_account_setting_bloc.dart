import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/user_account_setting/bloc/user_account_setting_event.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/user_account_setting/bloc/user_account_setting_state.dart';

class UserAccountSettingBloc
    extends Bloc<UserAccountSettingEvent, UserAccountSettingState> {
  UserAccountSettingBloc(this._getUserProfileUseCase)
    : super(UserAccountSettingInitialState()) {
    on<LoadUserAccountEvent>(_mapLoadUserAccountEventToState);
  }

  final GetUserProfileUseCase _getUserProfileUseCase;

  FutureOr<void> _mapLoadUserAccountEventToState(
    LoadUserAccountEvent event,
    Emitter<UserAccountSettingState> emit,
  ) async {
    emit(UserAccountLoadingState());

    final eitherResult = await _getUserProfileUseCase();
    eitherResult.fold((failure) {
      emit(UserAccountErrorState(failure.message ?? 'User account error'));
    }, (userAccount) => emit(UserAccountLoadedState(userAccount.email)));
  }
}
