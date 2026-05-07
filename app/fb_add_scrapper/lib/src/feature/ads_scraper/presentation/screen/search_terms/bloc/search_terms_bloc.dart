import 'dart:async';

import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/use_case/trigger_scrape_use_case.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/use_case/watch_search_terms_use_case.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/search_terms/bloc/search_terms_event.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/search_terms/bloc/search_terms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTermsBloc extends Bloc<SearchTermsEvent, SearchTermsState> {
  SearchTermsBloc({
    required TriggerScrapeUseCase triggerScrapeUseCase,
    required WatchSearchTermsUseCase watchSearchTermsUseCase,
  })  : _triggerScrape = triggerScrapeUseCase,
        _watchTerms = watchSearchTermsUseCase,
        super(const SearchTermsState()) {
    on<WatchSearchTermsEvent>(_onWatch);
    on<AddSearchTermEvent>(_onAdd);
  }

  final TriggerScrapeUseCase _triggerScrape;
  final WatchSearchTermsUseCase _watchTerms;

  // --------------------------------------------------------------------------

  FutureOr<void> _onWatch(
    WatchSearchTermsEvent event,
    Emitter<SearchTermsState> emit,
  ) async {
    await emit.forEach(
      _watchTerms(),
      onData: (terms) => state.copyWith(terms: terms),
      onError: (_, __) => state.copyWith(
        status: SearchTermsStatus.error,
        errorMessage: 'Failed to load search terms.',
      ),
    );
  }

  FutureOr<void> _onAdd(
    AddSearchTermEvent event,
    Emitter<SearchTermsState> emit,
  ) async {
    emit(state.copyWith(status: SearchTermsStatus.adding, errorMessage: null));

    final result = await _triggerScrape(
      TriggerScrapeInput(
        searchTerms: event.searchTerms,
        adType: event.adType,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchTermsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: SearchTermsStatus.idle)),
    );
  }
}

