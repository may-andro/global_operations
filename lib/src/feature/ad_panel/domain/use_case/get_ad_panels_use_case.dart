import 'dart:async';

import 'package:global_ops/src/feature/ad_panel/domain/entity/ad_panel_entity.dart';
import 'package:global_ops/src/feature/ad_panel/domain/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

class GetAdPanelsFailure extends BasicFailure {
  const GetAdPanelsFailure({super.message, super.cause});
}

class GetAdPanelsParams {
  const GetAdPanelsParams({this.page = 1, this.refresh = false});

  final int page;
  final bool refresh;
}

class GetAdPanelsUseCase
    extends
        BaseUseCase<
          List<AdPanelEntity>,
          GetAdPanelsParams,
          GetAdPanelsFailure
        > {
  GetAdPanelsUseCase(this._adPanelRepository);

  final AdPanelRepository _adPanelRepository;

  @protected
  @override
  FutureOr<Either<GetAdPanelsFailure, List<AdPanelEntity>>> execute(
    GetAdPanelsParams input,
  ) async {
    final adPanels = await _adPanelRepository.fetchAdPanels(
      page: input.page,
      refresh: input.refresh,
    );

    return Right(adPanels);
  }

  @override
  GetAdPanelsFailure mapErrorToFailure(Object e, StackTrace st) {
    return GetAdPanelsFailure(message: e.toString(), cause: st);
  }
}
