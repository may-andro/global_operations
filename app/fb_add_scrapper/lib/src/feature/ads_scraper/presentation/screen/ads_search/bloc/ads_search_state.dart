import 'package:equatable/equatable.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/search_term_entity.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

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
    this.filterQuery = '',
  });

  final List<SearchTermEntity> terms;
  final bool isAdding;
  final String? addError;
  final String filterQuery;

  /// Terms filtered by [filterQuery] (case-insensitive contains).
  /// Only applied when query is longer than 3 characters.
  List<SearchTermEntity> get filteredTerms {
    if (filterQuery.length <= 3) return terms;
    final lower = filterQuery.toLowerCase();
    return terms.where((t) => t.term.toLowerCase().contains(lower)).toList();
  }

  /// True when [filterQuery] exactly matches an existing term (case-insensitive).
  bool get isDuplicateQuery =>
      filterQuery.isNotEmpty &&
      terms.any((t) => t.term.toLowerCase() == filterQuery.toLowerCase());

  AdsSearchLoadedState copyWith({
    List<SearchTermEntity>? terms,
    bool? isAdding,
    String? addError,
    bool clearError = false,
    String? filterQuery,
  }) {
    return AdsSearchLoadedState(
      terms: terms ?? this.terms,
      isAdding: isAdding ?? this.isAdding,
      addError: clearError ? null : (addError ?? this.addError),
      filterQuery: filterQuery ?? this.filterQuery,
    );
  }

  @override
  List<Object?> get props => [terms, isAdding, addError, filterQuery];
}

final class AdsSearchErrorState extends AdsSearchState {
  const AdsSearchErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
