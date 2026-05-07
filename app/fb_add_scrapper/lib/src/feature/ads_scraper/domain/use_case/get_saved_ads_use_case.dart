import 'package:use_case/use_case.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/model.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/repository/repository.dart';

// --------------------------------------------------------------------------
// Failure
// --------------------------------------------------------------------------

class GetSavedAdsFailure extends BasicFailure {
  const GetSavedAdsFailure({super.message, super.cause});
}

// --------------------------------------------------------------------------
// Input
// --------------------------------------------------------------------------

class GetSavedAdsInput extends Equatable {
  const GetSavedAdsInput({this.limit, this.startAfterDocId});

  final int? limit;
  final String? startAfterDocId;

  @override
  List<Object?> get props => [limit, startAfterDocId];
}

// --------------------------------------------------------------------------
// Use Case
// --------------------------------------------------------------------------

/// Retrieves previously scraped & saved ads from Firestore, already
/// deduplicated (each ad_archive_id appears only once).
class GetSavedAdsUseCase
    extends BaseUseCase<List<FbAdModel>, GetSavedAdsInput, GetSavedAdsFailure> {
  GetSavedAdsUseCase(this._repository);

  final FbAdsRepository _repository;

  @override
  Future<Either<GetSavedAdsFailure, List<FbAdModel>>> execute(
    GetSavedAdsInput input,
  ) async {
    try {
      final ads = await _repository.getSavedAds(
        limit: input.limit,
        startAfterDocId: input.startAfterDocId,
      );
      return Right(ads);
    } catch (e, st) {
      return Left(GetSavedAdsFailure(message: e.toString(), cause: st));
    }
  }
}

