import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';

sealed class AdPanelSortOption {
  const AdPanelSortOption();

  String displayName(BuildContext context);

  String displayDescription(BuildContext context);

  IconData get icon;
}

final class ObjectNumberSortOption extends AdPanelSortOption {
  const ObjectNumberSortOption();

  @override
  String displayDescription(BuildContext context) {
    return context.localizations.adPanelSortObjectNumberSubtitle;
  }

  @override
  String displayName(BuildContext context) {
    return context.localizations.adPanelSortObjectNumberTitle;
  }

  @override
  IconData get icon => Icons.confirmation_num_rounded;
}

final class StreetSortOption extends AdPanelSortOption {
  const StreetSortOption();

  @override
  String displayDescription(BuildContext context) {
    return context.localizations.adPanelSortStreetSubtitle;
  }

  @override
  String displayName(BuildContext context) {
    return context.localizations.adPanelSortStreetTitle;
  }

  @override
  IconData get icon => Icons.directions;
}

final class LastEditedSortOption extends AdPanelSortOption {
  const LastEditedSortOption();

  @override
  String displayDescription(BuildContext context) {
    return context.localizations.adPanelSortEditedSubtitle;
  }

  @override
  String displayName(BuildContext context) {
    return context.localizations.adPanelSortEditedTitle;
  }

  @override
  IconData get icon => Icons.edit;
}

class DistanceSortOption extends AdPanelSortOption {
  const DistanceSortOption();

  @override
  String displayDescription(BuildContext context) {
    return context.localizations.adPanelSortDistanceSubtitle;
  }

  @override
  String displayName(BuildContext context) {
    return context.localizations.adPanelSortDistanceTitle;
  }

  @override
  IconData get icon => Icons.route;
}
