import 'package:equatable/equatable.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/search_term_entity.dart';

/// Base sealed class — mirrors the PaginatedAdPanels pattern.
sealed class AdsSearchState extends Equatable {
  const AdsSearchState();

  @override
  List<Object?> get props => [];
}

final class AdsSearchInitialState extends AdsSearchState {
  const AdsSearchInitialState();
}

final class AdsSearchLoadingState extends AdsSearchState {
  const AdsSearchLoadingState();
}

final class AdsSearchLoadedState extends AdsSearchState {
  const AdsSearchLoadedState({
    this.terms = const [],
    this.isAdding = false,
    this.addError,
  });

  final List<SearchTermEntity> terms;

  /// True while the Cloud Function call is in-flight.
  final bool isAdding;

  /// Non-null when the last triggerScrape call failed.
  final String? addError;

  AdsSearchLoadedState copyWith({
    List<SearchTermEntity>? terms,
    bool? isAdding,
    String? addError,
    bool clearError = false,
  }) {
    return AdsSearchLoadedState(
      terms: terms ?? this.terms,
      isAdding: isAdding ?? this.isAdding,
      addError: clearError ? null : (addError ?? this.addError),
    );
  }

  @override
  List<Object?> get props => [terms, isAdding, addError];
}

final class AdsSearchErrorState extends AdsSearchState {
  const AdsSearchErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

