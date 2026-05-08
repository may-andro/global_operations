import 'package:equatable/equatable.dart';

sealed class DateTimeValidationEvent extends Equatable {
  const DateTimeValidationEvent();

  @override
  List<Object?> get props => [];
}

class RequestDateTimeValidationEvent extends DateTimeValidationEvent {
  const RequestDateTimeValidationEvent();
}
