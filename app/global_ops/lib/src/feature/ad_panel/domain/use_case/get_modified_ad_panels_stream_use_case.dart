import 'dart:async';

import 'package:global_ops/src/feature/ad_panel/domain/entity/entity.dart';
import 'package:global_ops/src/feature/ad_panel/domain/repository/ad_panel_repository.dart';

class GetModifiedAdPanelsStreamUseCase {
  GetModifiedAdPanelsStreamUseCase(this._repository);

  final AdPanelRepository _repository;

  Stream<List<AdPanelEntity>> call() {
    return _repository.adPanelsUpdatedStream.distinct();
  }
}
