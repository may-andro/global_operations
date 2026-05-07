import 'package:equatable/equatable.dart';
import 'package:use_case/use_case.dart';
import 'package:either_dart/either.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/model.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/repository/repository.dart';

// --------------------------------------------------------------------------
// Failure
// --------------------------------------------------------------------------

class SearchAdsFailure extends BasicFailure {
  const SearchAdsFailure({super.message, super.cause});
}

// --------------------------------------------------------------------------
// Input
// --------------------------------------------------------------------------

class SearchAdsInput extends Equatable {
  const SearchAdsInput({
    required this.accessToken,
    required this.countries,
    this.searchTerms = '',
    this.adType = 'ALL',
    this.pageId,
    this.afterCursor,
    this.limit = 50,
    /// When true the fetched ads are automatically saved to Firestore.
    this.autoSave = true,
  });

  final String accessToken;
  final List<String> countries;
  final String searchTerms;
  final String adType;
  final String? pageId;
  final String? afterCursor;
  final int limit;
  final bool autoSave;

  @override
  List<Object?> get props => [
    accessToken,
    countries,
    searchTerms,
    adType,
    pageId,
    afterCursor,
    limit,
    autoSave,
  ];
}

// --------------------------------------------------------------------------
// Use case
// --------------------------------------------------------------------------

/// Fetches a page of ads from the Facebook Ads Library API and, when
/// [SearchAdsInput.autoSave] is `true`, persists them to Firestore (dedup
/// is handled at the repository level using ad_archive_id as the document key).
class SearchFbAdsUseCase
    extends BaseUseCase<FbAdsResponseModel, SearchAdsInput, SearchAdsFailure> {
  SearchFbAdsUseCase(this._repository);

  final FbAdsRepository _repository;

  @override
  Future<Either<SearchAdsFailure, FbAdsResponseModel>> execute(
    SearchAdsInput input,
  ) async {
    try {
      final response = await _repository.searchAds(
        accessToken: input.accessToken,
        countries: input.countries,
        searchTerms: input.searchTerms,
        adType: input.adType,
        pageId: input.pageId,
        afterCursor: input.afterCursor,
        limit: input.limit,
      );

      if (input.autoSave && response.ads.isNotEmpty) {
        // Fire-and-forget: don't block UI while saving.
        _repository.saveAds(response.ads).ignore();
      }

      return Right(response);
    } catch (e, st) {
      return Left(
        SearchAdsFailure(message: e.toString(), cause: st),
      );
    }
  }
}

