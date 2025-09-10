import 'package:equatable/equatable.dart';

sealed class DateTimeValidationState extends Equatable {
  const DateTimeValidationState();

  @override
  List<Object?> get props => [];
}

class DateTimeValidationInitialState extends DateTimeValidationState {
  const DateTimeValidationInitialState();
}

class DateTimeValidationProgressState extends DateTimeValidationState {
  const DateTimeValidationProgressState();
}

class DateTimeValidationValidState extends DateTimeValidationState {
  const DateTimeValidationValidState();
}

class DateTimeValidationInvalidState extends DateTimeValidationState {
  const DateTimeValidationInvalidState();
}
