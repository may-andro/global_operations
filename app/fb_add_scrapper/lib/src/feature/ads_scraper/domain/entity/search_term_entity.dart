import 'package:equatable/equatable.dart';

enum SearchTermStatus { pending, loading, done, error }

class SearchTermEntity extends Equatable {
  const SearchTermEntity({
    required this.id,
    required this.term,
    this.adType = 'ALL',
    this.status = SearchTermStatus.pending,
    this.totalCount = 0,
    this.lastFetchedAt,
    this.createdAt,
    this.errorMessage,
  });

  /// Firestore document ID — slugified search term.
  final String id;

  /// Original display text entered by the user.
  final String term;

  final String adType;
  final SearchTermStatus status;
  final int totalCount;
  final DateTime? lastFetchedAt;
  final DateTime? createdAt;
  final String? errorMessage;

  bool get isLoading => status == SearchTermStatus.loading;
  bool get isDone => status == SearchTermStatus.done;
  bool get hasError => status == SearchTermStatus.error;

  @override
  List<Object?> get props => [
    id,
    term,
    adType,
    status,
    totalCount,
    lastFetchedAt,
    createdAt,
    errorMessage,
  ];

  SearchTermEntity copyWith({
    String? id,
    String? term,
    String? adType,
    SearchTermStatus? status,
    int? totalCount,
    DateTime? lastFetchedAt,
    DateTime? createdAt,
    String? errorMessage,
  }) {
    return SearchTermEntity(
      id: id ?? this.id,
      term: term ?? this.term,
      adType: adType ?? this.adType,
      status: status ?? this.status,
      totalCount: totalCount ?? this.totalCount,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
      createdAt: createdAt ?? this.createdAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
