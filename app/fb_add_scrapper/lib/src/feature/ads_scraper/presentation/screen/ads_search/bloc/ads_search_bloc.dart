import 'dart:async';

import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/use_case/trigger_scrape_use_case.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/use_case/watch_search_terms_use_case.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/ads_search_event.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/ads_search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsSearchBloc extends Bloc<AdsSearchEvent, AdsSearchState> {
  AdsSearchBloc({
    required TriggerScrapeUseCase triggerScrapeUseCase,
    required WatchSearchTermsUseCase watchSearchTermsUseCase,
  }) : _triggerScrape = triggerScrapeUseCase,
       _watchTerms = watchSearchTermsUseCase,
       super(const AdsSearchInitialState()) {
    on<LoadAdsSearchEvent>(_onLoad);
    on<AddSearchTermEvent>(_onAdd);
    on<RetryAdsSearchEvent>(_onRetry);
    on<UpdateSearchQueryEvent>(_onUpdateQuery);
  }

  final TriggerScrapeUseCase _triggerScrape;
  final WatchSearchTermsUseCase _watchTerms;

  // --------------------------------------------------------------------------

  FutureOr<void> _onLoad(
    LoadAdsSearchEvent _,
    Emitter<AdsSearchState> emit,
  ) async {
    emit(const AdsSearchLoadingState());
    await emit.forEach(
      _watchTerms(),
      onData: (terms) {
        final current = state;
        if (current is AdsSearchLoadedState) {
          return current.copyWith(terms: terms);
        }
        return AdsSearchLoadedState(terms: terms);
      },
      onError: (err, __) =>
          const AdsSearchErrorState(message: 'Failed to load search terms.'),
    );
  }

  FutureOr<void> _onAdd(
    AddSearchTermEvent event,
    Emitter<AdsSearchState> emit,
  ) async {
    final current = state;
    if (current is! AdsSearchLoadedState) return;
    emit(current.copyWith(isAdding: true, clearError: true));
    final result = await _triggerScrape(
      TriggerScrapeInput(searchTerms: event.searchTerms, adType: event.adType),
    );
    final latest = state;
    if (latest is! AdsSearchLoadedState) return;
    result.fold(
      (failure) =>
          emit(latest.copyWith(isAdding: false, addError: failure.message)),
      (_) => emit(latest.copyWith(isAdding: false, clearError: true)),
    );
  }

  FutureOr<void> _onRetry(RetryAdsSearchEvent _, Emitter<AdsSearchState> emit) {
    add(const LoadAdsSearchEvent());
  }

  void _onUpdateQuery(
    UpdateSearchQueryEvent event,
    Emitter<AdsSearchState> emit,
  ) {
    final current = state;
    if (current is! AdsSearchLoadedState) return;
    emit(current.copyWith(filterQuery: event.query, clearError: true));
  }
}
