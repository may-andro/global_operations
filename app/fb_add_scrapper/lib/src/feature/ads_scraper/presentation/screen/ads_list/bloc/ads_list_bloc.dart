import 'dart:async';

import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/use_case/get_ads_for_term_use_case.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_list/bloc/ads_list_event.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_list/bloc/ads_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _kPageSize = 30;

class AdsListBloc extends Bloc<AdsListEvent, AdsListState> {
  AdsListBloc({required GetAdsForTermUseCase getAdsForTermUseCase})
    : _getAds = getAdsForTermUseCase,
      super(const AdsListState()) {
    on<LoadAdsListEvent>(_onLoad);
    on<LoadMoreAdsListEvent>(_onLoadMore);
    on<FilterAdsListEvent>(_onFilter);
  }

  final GetAdsForTermUseCase _getAds;

  // --------------------------------------------------------------------------

  FutureOr<void> _onLoad(
    LoadAdsListEvent event,
    Emitter<AdsListState> emit,
  ) async {
    emit(AdsListState(status: AdsListStatus.loading, termId: event.termId));

    final result = await _getAds(
      GetAdsForTermInput(termId: event.termId, limit: _kPageSize),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdsListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (ads) => emit(
        state.copyWith(
          status: AdsListStatus.success,
          ads: ads,
          hasMore: ads.length >= _kPageSize,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMore(
    LoadMoreAdsListEvent event,
    Emitter<AdsListState> emit,
  ) async {
    if (!state.hasMore || state.isLoading) return;

    emit(state.copyWith(status: AdsListStatus.loadingMore));

    final result = await _getAds(
      GetAdsForTermInput(
        termId: state.termId,
        limit: _kPageSize,
        startAfterDocId: state.lastDocId,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdsListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (newAds) => emit(
        state.copyWith(
          status: AdsListStatus.success,
          ads: [...state.ads, ...newAds],
          hasMore: newAds.length >= _kPageSize,
        ),
      ),
    );
  }

  void _onFilter(FilterAdsListEvent event, Emitter<AdsListState> emit) {
    if (event.clearAll) {
      emit(state.copyWith(filter: const AdsListFilter()));
      return;
    }
    // The widget always passes the full intended filter state — apply directly.
    emit(
      state.copyWith(
        filter: AdsListFilter(
          platform: event.platform,
          gender: event.gender,
          deliveryStatus: event.deliveryStatus,
        ),
      ),
    );
  }
}
