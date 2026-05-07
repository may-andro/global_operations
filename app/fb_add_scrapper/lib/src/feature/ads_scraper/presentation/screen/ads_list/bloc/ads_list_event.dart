import 'package:equatable/equatable.dart';

abstract class AdsListEvent extends Equatable {
  const AdsListEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdsListEvent extends AdsListEvent {
  const LoadAdsListEvent({required this.termId});

  final String termId;

  @override
  List<Object?> get props => [termId];
}

class LoadMoreAdsListEvent extends AdsListEvent {
  const LoadMoreAdsListEvent();
}

class FilterAdsListEvent extends AdsListEvent {
  const FilterAdsListEvent({
    this.platform,
    this.gender,
    this.deliveryStatus,
    this.clearAll = false,
  });

  /// e.g. 'facebook', 'instagram', 'messenger', 'audience_network'
  final String? platform;

  /// 'Men', 'Women', or null for all
  final String? gender;

  /// 'active', 'stopped', or null for all
  final String? deliveryStatus;

  /// When true, reset all filters.
  final bool clearAll;

  @override
  List<Object?> get props => [platform, gender, deliveryStatus, clearAll];
}
