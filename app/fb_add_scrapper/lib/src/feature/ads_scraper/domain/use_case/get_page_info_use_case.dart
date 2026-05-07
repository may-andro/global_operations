import 'package:equatable/equatable.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/repository/repository.dart';
import 'package:use_case/use_case.dart';

class GetPageInfoFailure extends BasicFailure {
  const GetPageInfoFailure({super.message, super.cause});
}

class GetPageInfoInput extends Equatable {
  const GetPageInfoInput({
    required this.accessToken,
    required this.pageId,
  });

  final String accessToken;
  final String pageId;

  @override
  List<Object?> get props => [accessToken, pageId];
}

/// Fetches public advertiser/page info from the Facebook Graph API.
class GetPageInfoUseCase
    extends BaseUseCase<FbPageInfoEntity?, GetPageInfoInput, GetPageInfoFailure> {
  GetPageInfoUseCase(this._repository);

  final FbAdsRepository _repository;

  @override
  Future<Either<GetPageInfoFailure, FbPageInfoEntity?>> execute(
    GetPageInfoInput input,
  ) async {
    try {
      final entity = await _repository.getPageInfo(
        accessToken: input.accessToken,
        pageId: input.pageId,
      );
      return Right(entity);
    } catch (e, st) {
      return Left(GetPageInfoFailure(message: e.toString(), cause: st));
    }
  }

  @override
  GetPageInfoFailure mapErrorToFailure(Object e, StackTrace st) =>
      GetPageInfoFailure(message: e.toString(), cause: e);
}

