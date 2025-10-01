import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/services/SpotifyAuthService.dart';

enum AppStatus {
  checking,
  loggedIn,
  loggedOut,
  offline,
}

class AuthNotifier extends ChangeNotifier {
  final SpotifyAuthService _authService = SpotifyAuthService();
  AppStatus _status = AppStatus.checking;
  AppStatus get status => _status;

  AuthNotifier() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = await _authService.getAccessToken();
    _status = token != null ? AppStatus.loggedIn : AppStatus.loggedOut;
    notifyListeners();
  }

  Future<void> handleAuthRedirect(Uri uri) async {
    final success = await _authService.handleRedirect(uri);
    if (success) {
      _status = AppStatus.loggedIn;
    } else {
      // If it fails, stay logged out
      _status = AppStatus.loggedOut;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _status = AppStatus.loggedOut;
    notifyListeners();
  }

  void enterOfflineMode() {
    _status = AppStatus.offline;
    notifyListeners();
  }
}