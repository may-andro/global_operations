import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';

sealed class AdPanelFilterOption {
  const AdPanelFilterOption();

  String displayName(BuildContext context);

  String displayDescription(BuildContext context);

  String searchHintText(BuildContext context);

  IconData get icon;

  String get key;

  int? get paginationLimit => null;

  int get defaultPaginationLimit => 30;
}

final class ObjectNumberFilterOption extends AdPanelFilterOption {
  const ObjectNumberFilterOption();

  @override
  String displayDescription(BuildContext context) {
    return context.localizations.adPanelSearchFilterObjectNumberDescription;
  }

  @override
  String displayName(BuildContext context) {
    return context.localizations.adPanelSearchFilterObjectNumber;
  }

  @override
  String searchHintText(BuildContext context) {
    return context.localizations.adPanelSearchFilterObjectNumberHint;
  }

  @override
  IconData get icon => Icons.confirmation_num_rounded;

  @override
  String get key => 'OBJECTNR';

  @override
  int get paginationLimit => 50;
}

final class StreetFilterOption extends AdPanelFilterOption {
  const StreetFilterOption();

  @override
  String displayDescription(BuildContext context) {
    return context.localizations.adPanelSearchFilterStreetDescription;
  }

  @override
  String displayName(BuildContext context) {
    return context.localizations.adPanelSearchFilterStreet;
  }

  @override
  String searchHintText(BuildContext context) {
    return context.localizations.adPanelSearchFilterStreetHint;
  }

  @override
  IconData get icon => Icons.directions;

  @override
  String get key => 'STREET';
}

class MunicipalityFilterOption extends AdPanelFilterOption {
  const MunicipalityFilterOption();

  @override
  String displayDescription(BuildContext context) {
    return context.localizations.adPanelSearchFilterMunicipalityDescription;
  }

  @override
  String displayName(BuildContext context) {
    return context.localizations.adPanelSearchFilterMunicipality;
  }

  @override
  String searchHintText(BuildContext context) {
    return context.localizations.adPanelSearchFilterMunicipalityHint;
  }

  @override
  IconData get icon => Icons.location_city_rounded;

  @override
  String get key => 'MUNICIPALITY_PART';
}
