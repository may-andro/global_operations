import 'package:equatable/equatable.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/repository/repository.dart';
import 'package:use_case/use_case.dart';

// --------------------------------------------------------------------------
// Failure
// --------------------------------------------------------------------------

class GetAdsForTermFailure extends BasicFailure {
  const GetAdsForTermFailure({super.message, super.cause});
}

// --------------------------------------------------------------------------
// Input
// --------------------------------------------------------------------------

class GetAdsForTermInput extends Equatable {
  const GetAdsForTermInput({
    required this.termId,
    this.limit,
    this.startAfterDocId,
  });

  final String termId;
  final int? limit;
  final String? startAfterDocId;

  @override
  List<Object?> get props => [termId, limit, startAfterDocId];
}

// --------------------------------------------------------------------------
// Use case
// --------------------------------------------------------------------------

class GetAdsForTermUseCase
    extends
        BaseUseCase<
          List<FbAdEntity>,
          GetAdsForTermInput,
          GetAdsForTermFailure
        > {
  GetAdsForTermUseCase(this._repository);

  final FbAdsRepository _repository;

  @override
  Future<Either<GetAdsForTermFailure, List<FbAdEntity>>> execute(
    GetAdsForTermInput input,
  ) async {
    try {
      final ads = await _repository.getAdsForTerm(
        input.termId,
        limit: input.limit,
        startAfterDocId: input.startAfterDocId,
      );
      return Right(ads);
    } catch (e, st) {
      return Left(GetAdsForTermFailure(message: e.toString(), cause: st));
    }
  }

  @override
  GetAdsForTermFailure mapErrorToFailure(Object e, StackTrace st) =>
      GetAdsForTermFailure(message: e.toString(), cause: e);
}
