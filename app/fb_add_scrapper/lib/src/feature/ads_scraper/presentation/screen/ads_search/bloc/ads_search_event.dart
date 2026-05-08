import 'package:equatable/equatable.dart';

sealed class AdsSearchEvent extends Equatable {
  const AdsSearchEvent();

  @override
  List<Object?> get props => [];
}

final class LoadAdsSearchEvent extends AdsSearchEvent {
  const LoadAdsSearchEvent();
}

final class AddSearchTermEvent extends AdsSearchEvent {
  const AddSearchTermEvent({required this.searchTerms, this.adType = 'ALL'});

  final String searchTerms;
  final String adType;

  @override
  List<Object?> get props => [searchTerms, adType];
}

final class RetryAdsSearchEvent extends AdsSearchEvent {
  const RetryAdsSearchEvent();
}

final class UpdateSearchQueryEvent extends AdsSearchEvent {
  const UpdateSearchQueryEvent({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}
