import 'package:equatable/equatable.dart';

abstract class AdsScrapeEvent extends Equatable {
  const AdsScrapeEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger a fresh search (resets pagination).
class SearchAdsEvent extends AdsScrapeEvent {
  const SearchAdsEvent({
    required this.searchTerms,
    required this.countries,
    this.adType = 'ALL',
    this.pageId,
  });

  final String searchTerms;
  final List<String> countries;
  final String adType;
  final String? pageId;

  @override
  List<Object?> get props => [searchTerms, countries, adType, pageId];
}

/// Load the next page using the cursor from the previous response.
class LoadMoreAdsEvent extends AdsScrapeEvent {
  const LoadMoreAdsEvent();
}

/// Load ads already saved in Firestore.
class LoadSavedAdsEvent extends AdsScrapeEvent {
  const LoadSavedAdsEvent();
}

/// Delete a saved ad from Firestore.
class DeleteSavedAdEvent extends AdsScrapeEvent {
  const DeleteSavedAdEvent(this.adArchiveId);

  final String adArchiveId;

  @override
  List<Object?> get props => [adArchiveId];
}

