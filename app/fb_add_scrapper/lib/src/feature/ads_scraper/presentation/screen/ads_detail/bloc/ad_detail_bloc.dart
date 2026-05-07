import 'dart:async';

import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/fb_page_info_entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/use_case/get_page_info_use_case.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/bloc/ad_detail_event.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/bloc/ad_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdDetailBloc extends Bloc<AdDetailEvent, AdDetailState> {
  AdDetailBloc({required this.getPageInfoUseCase})
    : super(const AdDetailState()) {
    on<LoadPageInfoEvent>(_onLoadPageInfo);
  }

  final GetPageInfoUseCase getPageInfoUseCase;

  FutureOr<void> _onLoadPageInfo(
    LoadPageInfoEvent event,
    Emitter<AdDetailState> emit,
  ) async {
    emit(state.copyWith(status: AdDetailPageInfoStatus.loading));

    final result = await getPageInfoUseCase(
      GetPageInfoInput(pageId: event.pageId),
    );

    result.fold(
      (GetPageInfoFailure failure) => emit(
        state.copyWith(
          status: AdDetailPageInfoStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (FbPageInfoEntity? pageInfo) => emit(
        state.copyWith(
          status: AdDetailPageInfoStatus.success,
          pageInfo: pageInfo,
        ),
      ),
    );
  }
}
