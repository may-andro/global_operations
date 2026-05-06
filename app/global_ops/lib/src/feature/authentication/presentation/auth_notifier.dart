import 'dart:async';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';

/// Notifies listeners about authentication state changes for routing purposes.
///
/// This class is specifically designed to work with the router's redirect logic
/// to handle authentication-based navigation decisions.
class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._getUserProfileStreamUseCase) {
    _initializeAuthListener();
  }

  final GetUserProfileStreamUseCase _getUserProfileStreamUseCase;
  StreamSubscription<UserProfileEntity?>? _authSubscription;

  UserProfileEntity? _userProfile;
  bool _isInitialized = false;

  /// Whether a user is currently logged in.
  bool get isLoggedIn => _userProfile != null;

  /// Whether the authentication state has been initialized.
  bool get isInitialized => _isInitialized;

  void _initializeAuthListener() {
    _authSubscription?.cancel();

    // Set a timeout for initialization in case the stream doesn't emit
    Timer(const Duration(seconds: 3), () {
      if (!_isInitialized) {
        _setUnauthenticatedState();
      }
    });

    _authSubscription = _getUserProfileStreamUseCase().listen(
      _handleAuthStateChange,
      onError: (_) => _setUnauthenticatedState(),
    );
  }

  void _handleAuthStateChange(UserProfileEntity? userProfile) {
    final wasLoggedIn = isLoggedIn;
    final wasInitialized = _isInitialized;

    _userProfile = userProfile;
    _isInitialized = true;

    // Notify listeners if this is the first initialization or auth state changed
    if (!wasInitialized || wasLoggedIn != isLoggedIn) {
      notifyListeners();
    }
  }

  void _setUnauthenticatedState() {
    _userProfile = null;
    _isInitialized = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
