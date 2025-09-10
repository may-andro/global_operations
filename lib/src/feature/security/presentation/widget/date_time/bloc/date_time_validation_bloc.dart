import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/security/domain/domain.dart';
import 'package:global_ops/src/feature/security/presentation/widget/date_time/bloc/date_time_validation_event.dart';
import 'package:global_ops/src/feature/security/presentation/widget/date_time/bloc/date_time_validation_state.dart';

class DateTimeValidationBloc
    extends Bloc<DateTimeValidationEvent, DateTimeValidationState> {
  DateTimeValidationBloc(this._dateTimeValidationUseCase)
    : super(const DateTimeValidationInitialState()) {
    on<RequestDateTimeValidationEvent>(
      _mapRequestDateTimeValidationEventToState,
    );
  }

  final DateTimeValidationUseCase _dateTimeValidationUseCase;

  Future<void> _mapRequestDateTimeValidationEventToState(
    RequestDateTimeValidationEvent event,
    Emitter<DateTimeValidationState> emit,
  ) async {
    emit(const DateTimeValidationProgressState());
    final result = await _dateTimeValidationUseCase();
    result.fold(
      (failure) => emit(const DateTimeValidationInvalidState()),
      (isValidated) => emit(
        isValidated
            ? const DateTimeValidationValidState()
            : const DateTimeValidationInvalidState(),
      ),
    );
  }
}
