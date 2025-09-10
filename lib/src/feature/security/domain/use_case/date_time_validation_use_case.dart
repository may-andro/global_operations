import 'dart:async';

import 'package:global_ops/src/feature/security/domain/repository/date_time_security_repository.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

class DateTimeValidationFailure extends BasicFailure {
  const DateTimeValidationFailure({super.message, super.cause});
}

class DateTimeValidationUseCase
    extends BaseNoParamUseCase<bool, DateTimeValidationFailure> {
  DateTimeValidationUseCase(this._dateTimeSecurityRepository);

  final DateTimeSecurityRepository _dateTimeSecurityRepository;

  @protected
  @override
  FutureOr<Either<DateTimeValidationFailure, bool>> execute() async {
    final isd = await _dateTimeSecurityRepository.validateDateTime();
    return Right(isd);
  }

  @override
  DateTimeValidationFailure mapErrorToFailure(Object e, StackTrace st) {
    return DateTimeValidationFailure(message: e.toString(), cause: e);
  }
}
