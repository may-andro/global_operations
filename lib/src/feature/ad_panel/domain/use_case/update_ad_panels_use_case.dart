import 'dart:async';

import 'package:core/core.dart';
import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/ad_panel/domain/entity/ad_panel_entity.dart';
import 'package:global_ops/src/feature/ad_panel/domain/repository/repository.dart';
import 'package:global_ops/src/feature/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

sealed class UpdateAdPanelsFailure extends BasicFailure {
  const UpdateAdPanelsFailure({super.message, super.cause});
}

class UpdateAdPanelsUserNotFoundFailure extends UpdateAdPanelsFailure {
  const UpdateAdPanelsUserNotFoundFailure({super.message, super.cause});
}

class UpdateAdPanelsValidationFailure extends UpdateAdPanelsFailure {
  const UpdateAdPanelsValidationFailure({super.message, super.cause});
}

class UpdateAdPanelsServerFailure extends UpdateAdPanelsFailure {
  const UpdateAdPanelsServerFailure({super.message, super.cause});
}

class UpdateAdPanelsUnknownFailure extends UpdateAdPanelsFailure {
  const UpdateAdPanelsUnknownFailure({super.message, super.cause});
}

class UpdateAdPanelsUseCase
    extends BaseUseCase<void, List<AdPanelEntity>, UpdateAdPanelsFailure> {
  UpdateAdPanelsUseCase(this._adPanelRepository, this._getUserProfileUseCase);

  final AdPanelRepository _adPanelRepository;
  final GetUserProfileUseCase _getUserProfileUseCase;

  @protected
  @override
  FutureOr<Either<UpdateAdPanelsFailure, void>> execute(
    List<AdPanelEntity> input,
  ) async {
    // Validate input
    if (input.isEmpty) {
      return const Left(
        UpdateAdPanelsValidationFailure(
          message: 'No ad panels provided for update',
        ),
      );
    }

    // Get user profile
    final eitherUser = await _getUserProfileUseCase();
    if (eitherUser.isLeft) {
      return const Left(
        UpdateAdPanelsUserNotFoundFailure(
          message: 'Failed to get user profile',
        ),
      );
    }

    final user = eitherUser.right;
    final enrichedPanels = input.map((panel) {
      return panel.copyWith(
        updatedAt: DateTime.now().toFormattedDateTime,
        updatedBy: user.email,
      );
    }).toList();

    await _adPanelRepository.updateAdPanels(enrichedPanels);
    return const Right(null);
  }

  @override
  UpdateAdPanelsFailure mapErrorToFailure(Object e, StackTrace st) {
    if (e is FirestoreException) {
      return UpdateAdPanelsServerFailure(
        message: 'Failed to update ad panels in Firestore',
        cause: e,
      );
    }

    // Default to unknown failure
    return UpdateAdPanelsUnknownFailure(
      message: 'An unexpected error occurred while updating ad panels',
      cause: e,
    );
  }
}
