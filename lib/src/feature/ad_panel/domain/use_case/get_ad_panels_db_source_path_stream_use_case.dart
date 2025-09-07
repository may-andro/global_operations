import 'dart:async';

import 'package:global_ops/src/feature/ad_panel/domain/repository/repository.dart';

class GetAdPanelsDbSourcePathStreamUseCase {
  GetAdPanelsDbSourcePathStreamUseCase(this._adPanelRepository);

  final AdPanelRepository _adPanelRepository;

  Stream<String> call() {
    return _adPanelRepository.collectionPathStream.distinct();
  }
}
