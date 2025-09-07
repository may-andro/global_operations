import 'dart:async';

import 'package:global_ops/src/feature/ad_panel/domain/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

class GetAdPanelsDbSourcePathsUseCase
    extends BaseNoParamUseCase<List<String>, NoFailure> {
  GetAdPanelsDbSourcePathsUseCase(this._adPanelRepository);

  final AdPanelRepository _adPanelRepository;

  @protected
  @override
  FutureOr<Either<NoFailure, List<String>>> execute() {
    return Right(_adPanelRepository.collectionPaths);
  }

  @override
  NoFailure mapErrorToFailure(Object e, StackTrace st) {
    return NoFailure();
  }
}
