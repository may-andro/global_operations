import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FeatureFlag extends Equatable {
  const FeatureFlag(this.feature, this.isEnabled);

  final Feature feature;
  final bool isEnabled;

  @override
  List<Object?> get props => [feature, isEnabled];
}

enum Feature {
  adPanelDetail(
    key: 'feature_ad_panel_details',
    title: 'Ad Panel Details',
    icon: Icons.ad_units_rounded,
  ),
  adPanelSearch(
    key: 'feature_ad_panel_search',
    title: 'Ad Panel Search',
    icon: Icons.search_rounded,
  ),
  adPanelSort(
    key: 'feature_ad_panel_sorting',
    title: 'Ad Panel Sort',
    icon: Icons.sort_rounded,
  ),
  cameraSupport(
    key: 'feature_camera_support',
    title: 'Camera Support',
    icon: Icons.camera_alt_rounded,
  ),
  deleteAccount(
    key: 'feature_delete_account',
    title: 'Delete Account',
    icon: Icons.delete_forever_rounded,
  ),
  googleMap(key: 'feature_google_map', title: 'Google Map', icon: Icons.map),
  locationSearch(
    key: 'feature_location_search',
    title: 'Location Search',
    icon: Icons.location_on,
  );

  const Feature({required this.key, required this.title, required this.icon});

  factory Feature.getFeature(String key) {
    return Feature.values.firstWhere((feature) => feature.key == key);
  }

  final String key;
  final String title;
  final IconData icon;

  static Map<String, dynamic> get defaultConfigsMap {
    final defaultConfigMap = <String, dynamic>{};
    for (final value in values) {
      defaultConfigMap[value.key] = false;
    }
    return defaultConfigMap;
  }
}
