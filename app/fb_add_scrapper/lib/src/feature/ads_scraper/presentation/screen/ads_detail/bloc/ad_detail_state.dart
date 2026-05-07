import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/fb_page_info_entity.dart';

enum AdDetailPageInfoStatus { idle, loading, success, failure }

class AdDetailState {
  const AdDetailState({
    this.status = AdDetailPageInfoStatus.idle,
    this.pageInfo,
    this.errorMessage,
  });

  final AdDetailPageInfoStatus status;
  final FbPageInfoEntity? pageInfo;
  final String? errorMessage;

  AdDetailState copyWith({
    AdDetailPageInfoStatus? status,
    FbPageInfoEntity? pageInfo,
    String? errorMessage,
  }) {
    return AdDetailState(
      status: status ?? this.status,
      pageInfo: pageInfo ?? this.pageInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

