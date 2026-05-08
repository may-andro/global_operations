import 'package:equatable/equatable.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';

enum AdsListStatus { idle, loading, loadingMore, success, failure }

class AdsListFilter extends Equatable {
  const AdsListFilter({this.platform, this.gender});

  /// e.g. 'facebook', 'instagram'
  final String? platform;

  /// 'Men', 'Women', or null for all
  final String? gender;

  bool get isActive => platform != null || gender != null;

  AdsListFilter copyWith({
    Object? platform = _sentinel,
    Object? gender = _sentinel,
  }) {
    return AdsListFilter(
      platform: platform == _sentinel ? this.platform : platform as String?,
      gender: gender == _sentinel ? this.gender : gender as String?,
    );
  }

  @override
  List<Object?> get props => [platform, gender];
}

// Sentinel to distinguish "not provided" from null
const _sentinel = Object();

class AdsListState extends Equatable {
  const AdsListState({
    this.status = AdsListStatus.idle,
    this.termId = '',
    this.ads = const [],
    this.hasMore = true,
    this.errorMessage,
    this.filter = const AdsListFilter(),
  });

  final AdsListStatus status;
  final String termId;
  final List<FbAdEntity> ads;
  final bool hasMore;
  final String? errorMessage;
  final AdsListFilter filter;

  bool get isLoading =>
      status == AdsListStatus.loading || status == AdsListStatus.loadingMore;

  String? get lastDocId => ads.isNotEmpty ? ads.last.id : null;

  /// Returns the ads after applying active filters.
  List<FbAdEntity> get filteredAds {
    if (!filter.isActive) return ads;
    return ads.where((ad) {
      if (filter.platform != null) {
        final platforms = ad.publisherPlatforms
            ?.map((p) => p.toLowerCase())
            .toList();
        if (platforms == null ||
            !platforms.contains(filter.platform!.toLowerCase())) {
          return false;
        }
      }
      if (filter.gender != null) {
        if (ad.targetGender?.toLowerCase() != filter.gender!.toLowerCase()) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  AdsListState copyWith({
    AdsListStatus? status,
    String? termId,
    List<FbAdEntity>? ads,
    bool? hasMore,
    String? errorMessage,
    AdsListFilter? filter,
  }) {
    return AdsListState(
      status: status ?? this.status,
      termId: termId ?? this.termId,
      ads: ads ?? this.ads,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [
    status,
    termId,
    ads,
    hasMore,
    errorMessage,
    filter,
  ];
}
