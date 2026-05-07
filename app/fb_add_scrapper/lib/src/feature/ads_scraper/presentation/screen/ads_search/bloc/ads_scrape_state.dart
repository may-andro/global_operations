import 'package:equatable/equatable.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';

enum AdsScrapeStatus { idle, loading, loadingMore, success, failure }

class AdsScrapeState extends Equatable {
  const AdsScrapeState({
    this.status = AdsScrapeStatus.idle,
    this.ads = const [],
    this.savedAds = const [],
    this.nextCursor,
    this.hasNextPage = false,
    this.errorMessage,
    // Search params kept in state so pagination carries them forward.
    this.searchTerms = '',
    this.countries = const ['US'],
    this.adType = 'ALL',
    this.pageId,
  });

  final AdsScrapeStatus status;
  final List<FbAdEntity> ads;
  final List<FbAdEntity> savedAds;
  final String? nextCursor;
  final bool hasNextPage;
  final String? errorMessage;
  final String searchTerms;
  final List<String> countries;
  final String adType;
  final String? pageId;

  bool get isLoading =>
      status == AdsScrapeStatus.loading ||
      status == AdsScrapeStatus.loadingMore;

  AdsScrapeState copyWith({
    AdsScrapeStatus? status,
    List<FbAdEntity>? ads,
    List<FbAdEntity>? savedAds,
    String? nextCursor,
    bool? hasNextPage,
    String? errorMessage,
    String? searchTerms,
    List<String>? countries,
    String? adType,
    String? pageId,
  }) {
    return AdsScrapeState(
      status: status ?? this.status,
      ads: ads ?? this.ads,
      savedAds: savedAds ?? this.savedAds,
      nextCursor: nextCursor ?? this.nextCursor,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: errorMessage ?? this.errorMessage,
      searchTerms: searchTerms ?? this.searchTerms,
      countries: countries ?? this.countries,
      adType: adType ?? this.adType,
      pageId: pageId ?? this.pageId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    ads,
    savedAds,
    nextCursor,
    hasNextPage,
    errorMessage,
    searchTerms,
    countries,
    adType,
    pageId,
  ];
}

