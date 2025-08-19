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
  contactUsHomeFab(
    key: 'feature_location',
    title: 'Location',
    icon: Icons.gps_fixed,
  ),
  languageSwitcher(
    key: 'feature_language_switcher',
    title: 'Language Switcher',
    icon: Icons.language,
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
