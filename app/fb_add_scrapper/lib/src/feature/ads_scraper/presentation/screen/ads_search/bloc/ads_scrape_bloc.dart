import 'dart:async';

import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/repository/repository.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/use_case/use_case.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/ads_scrape_event.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/ads_scrape_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// **Important:** store your access token securely (e.g. via Firebase Remote
/// Config or an encrypted secret store). Never hard-code it in source.
class AdsScrapeBloc extends Bloc<AdsScrapeEvent, AdsScrapeState> {
  AdsScrapeBloc({
    required this.searchUseCase,
    required this.getSavedAdsUseCase,
    required this.repository,
    required this.accessToken,
  }) : super(const AdsScrapeState()) {
    on<SearchAdsEvent>(_onSearch);
    on<LoadMoreAdsEvent>(_onLoadMore);
    on<LoadSavedAdsEvent>(_onLoadSaved);
    on<DeleteSavedAdEvent>(_onDelete);
  }

  final SearchFbAdsUseCase searchUseCase;
  final GetSavedAdsUseCase getSavedAdsUseCase;
  final FbAdsRepository repository;

  /// A valid Facebook user access token with `ads_read` permission.
  final String accessToken;

  // --------------------------------------------------------------------------
  // Handlers
  // --------------------------------------------------------------------------

  FutureOr<void> _onSearch(
    SearchAdsEvent event,
    Emitter<AdsScrapeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AdsScrapeStatus.loading,
        ads: [],
        nextCursor: null,
        hasNextPage: false,
        errorMessage: null,
        searchTerms: event.searchTerms,
        countries: event.countries,
        adType: event.adType,
        pageId: event.pageId,
      ),
    );

    final result = await searchUseCase(
      SearchAdsInput(
        accessToken: accessToken,
        countries: event.countries,
        searchTerms: event.searchTerms,
        adType: event.adType,
        pageId: event.pageId,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdsScrapeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: AdsScrapeStatus.success,
          ads: response.ads,
          nextCursor: response.nextCursor,
          hasNextPage: response.hasNextPage,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMore(
    LoadMoreAdsEvent event,
    Emitter<AdsScrapeState> emit,
  ) async {
    if (!state.hasNextPage || state.isLoading) return;

    emit(state.copyWith(status: AdsScrapeStatus.loadingMore));

    final result = await searchUseCase(
      SearchAdsInput(
        accessToken: accessToken,
        countries: state.countries,
        searchTerms: state.searchTerms,
        adType: state.adType,
        pageId: state.pageId,
        afterCursor: state.nextCursor,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdsScrapeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: AdsScrapeStatus.success,
          ads: [...state.ads, ...response.ads],
          nextCursor: response.nextCursor,
          hasNextPage: response.hasNextPage,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadSaved(
    LoadSavedAdsEvent event,
    Emitter<AdsScrapeState> emit,
  ) async {
    final result = await getSavedAdsUseCase(const GetSavedAdsInput());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdsScrapeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (ads) => emit(state.copyWith(savedAds: ads)),
    );
  }

  FutureOr<void> _onDelete(
    DeleteSavedAdEvent event,
    Emitter<AdsScrapeState> emit,
  ) async {
    await repository.deleteAd(event.adArchiveId);
    final updatedSaved =
        state.savedAds.where((a) => a.id != event.adArchiveId).toList();
    emit(state.copyWith(savedAds: updatedSaved));
  }
}

