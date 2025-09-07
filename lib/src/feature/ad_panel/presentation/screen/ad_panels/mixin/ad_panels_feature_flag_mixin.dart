import 'package:core/core.dart';
import 'package:global_ops/src/feature/feature_toggle/feature_toggle.dart';
import 'package:meta/meta.dart';

mixin AdPanelFeatureFLagsMixin {
  IsFeatureEnabledUseCase get isFeatureEnabledUseCase;

  bool _isAdPanelDetailEnabled = false;

  bool _isAdPanelSortEnabled = false;

  bool _isAdPanelSearchEnabled = false;

  bool _isAdPanelGoogleMapEnabled = false;

  bool get isAdPanelDetailEnabled => _isAdPanelDetailEnabled;

  bool get isAdPanelSortEnabled => _isAdPanelSortEnabled;

  bool get isAdPanelSearchEnabled => _isAdPanelSearchEnabled;

  bool get isAdPanelGoogleMapEnabled => _isAdPanelGoogleMapEnabled;

  @protected
  Future<void> initializeFeatureFlags() async {
    await Future.wait([
      _isAdPanelDetailsFeatureEnabled(),
      _isAdPanelSortFeatureEnabled(),
      _isAdPanelSearchFeatureEnabled(),
      _isAdPanelGoogleMapFeatureEnabled(),
    ]);
  }

  Future<void> _isAdPanelDetailsFeatureEnabled() async {
    final eitherResult = await isFeatureEnabledUseCase(Feature.adPanelDetail);
    _isAdPanelDetailEnabled = eitherResult.fold(
      (failure) => false,
      (isEnabled) => isEnabled,
    );
  }

  Future<void> _isAdPanelSortFeatureEnabled() async {
    final eitherResult = await isFeatureEnabledUseCase(Feature.adPanelSort);
    _isAdPanelSortEnabled = eitherResult.fold(
      (failure) => false,
      (isEnabled) => isEnabled,
    );
  }

  Future<void> _isAdPanelSearchFeatureEnabled() async {
    final eitherResult = await isFeatureEnabledUseCase(Feature.adPanelSearch);
    _isAdPanelSearchEnabled = eitherResult.fold(
      (failure) => false,
      (isEnabled) => isEnabled,
    );
  }

  Future<void> _isAdPanelGoogleMapFeatureEnabled() async {
    final eitherResult = await isFeatureEnabledUseCase(Feature.googleMap);
    _isAdPanelGoogleMapEnabled = eitherResult.fold(
      (failure) => false,
      (isEnabled) => isEnabled,
    );
  }
}
