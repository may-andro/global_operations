import 'package:equatable/equatable.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/search_term_entity.dart';

enum SearchTermsStatus { idle, adding, error }

class SearchTermsState extends Equatable {
  const SearchTermsState({
    this.status = SearchTermsStatus.idle,
    this.terms = const [],
    this.errorMessage,
  });

  final SearchTermsStatus status;
  final List<SearchTermEntity> terms;
  final String? errorMessage;

  SearchTermsState copyWith({
    SearchTermsStatus? status,
    List<SearchTermEntity>? terms,
    String? errorMessage,
  }) {
    return SearchTermsState(
      status: status ?? this.status,
      terms: terms ?? this.terms,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, terms, errorMessage];
}

