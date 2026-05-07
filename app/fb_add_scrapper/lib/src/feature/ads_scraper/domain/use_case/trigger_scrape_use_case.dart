import 'package:equatable/equatable.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/repository/repository.dart';
import 'package:use_case/use_case.dart';

// --------------------------------------------------------------------------
// Failure
// --------------------------------------------------------------------------

class TriggerScrapeFailure extends BasicFailure {
  const TriggerScrapeFailure({super.message, super.cause});
}

// --------------------------------------------------------------------------
// Input
// --------------------------------------------------------------------------

class TriggerScrapeInput extends Equatable {
  const TriggerScrapeInput({
    required this.searchTerms,
    this.adType = 'ALL',
  });

  final String searchTerms;
  final String adType;

  @override
  List<Object?> get props => [searchTerms, adType];
}

// --------------------------------------------------------------------------
// Use case
// --------------------------------------------------------------------------

/// Calls the Cloud Function to scrape up to 1000 ads into Firestore and
/// returns the [termId] so the UI can start streaming immediately.
class TriggerScrapeUseCase
    extends BaseUseCase<String, TriggerScrapeInput, TriggerScrapeFailure> {
  TriggerScrapeUseCase(this._repository);

  final FbAdsRepository _repository;

  @override
  Future<Either<TriggerScrapeFailure, String>> execute(
    TriggerScrapeInput input,
  ) async {
    try {
      final termId = await _repository.triggerScrape(
        searchTerms: input.searchTerms,
        adType: input.adType,
      );
      return Right(termId);
    } catch (e, st) {
      return Left(TriggerScrapeFailure(message: e.toString(), cause: st));
    }
  }

  @override
  TriggerScrapeFailure mapErrorToFailure(Object e, StackTrace st) =>
      TriggerScrapeFailure(message: e.toString(), cause: e);
}

