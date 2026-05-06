import 'dart:async';

import 'package:global_ops/src/feature/ad_panel/domain/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

class ResetModifiedAdPanelsUseCase extends BaseNoParamUseCase<void, NoFailure> {
  ResetModifiedAdPanelsUseCase(this._adPanelRepository);

  final AdPanelRepository _adPanelRepository;

  @protected
  @override
  FutureOr<Either<NoFailure, void>> execute() {
    _adPanelRepository.cleanRefreshedAdPanels();
    return const Right(null);
  }

  @override
  NoFailure mapErrorToFailure(Object e, StackTrace st) {
    return NoFailure();
  }
}
