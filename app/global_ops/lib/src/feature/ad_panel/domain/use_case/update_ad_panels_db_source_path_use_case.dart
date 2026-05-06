import 'dart:async';

import 'package:global_ops/src/feature/ad_panel/domain/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

class UpdateAdPanelsDbSourcePathFailure extends BasicFailure {
  const UpdateAdPanelsDbSourcePathFailure({super.message, super.cause});
}

class UpdateAdPanelsDbSourcePathUseCase
    extends BaseUseCase<void, String, UpdateAdPanelsDbSourcePathFailure> {
  UpdateAdPanelsDbSourcePathUseCase(this._adPanelRepository);

  final AdPanelRepository _adPanelRepository;

  @protected
  @override
  FutureOr<Either<UpdateAdPanelsDbSourcePathFailure, void>> execute(
    String input,
  ) async {
    final adPanels = await _adPanelRepository.updateCollectionPath(input);

    return Right(adPanels);
  }

  @override
  UpdateAdPanelsDbSourcePathFailure mapErrorToFailure(Object e, StackTrace st) {
    return UpdateAdPanelsDbSourcePathFailure(message: e.toString(), cause: st);
  }
}
