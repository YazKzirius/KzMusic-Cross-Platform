import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class SpotifyAuthService {
  static const String _clientId = '21dc131ad4524c6aae75a9d0256b1b70';

  static String get _redirectUri {
    if (kIsWeb) {
      return 'http://localhost:9999/callback';
    }
    if (Platform.isAndroid || Platform.isIOS) {
      return 'kzmusiccrossplatform://callback';
    } else {
      // This will now cover Windows, macOS, and Linux.
      // They will use the same web-based redirect flow.
      return 'http://localhost:9999/callback';
    }
  }

  static const String _scope = 'user-read-private user-read-email';

  // We no longer need this instance variable as we will use SharedPreferences
  // String _codeVerifier = '';

  /// Initiates the Spotify authentication flow.
  Future<void> authenticate() async {
    final codeVerifier = _generateRandomString(128);

    // --- FIX 1: SAVE the code_verifier before launching the URL ---
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('spotify_code_verifier', codeVerifier);

    final codeChallenge = _generateCodeChallenge(codeVerifier);

    final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
      'client_id': _clientId,
      'response_type': 'code',
      'redirect_uri': _redirectUri,
      'scope': _scope,
      'code_challenge_method': 'S256',
      'code_challenge': codeChallenge,
    });

    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, webOnlyWindowName: '_self');
    } else {
      throw 'Could not launch $authUrl';
    }
  }

  /// Handles the redirect from Spotify, exchanges the code for a token, and stores it.
  Future<bool> handleRedirect(Uri uri) async {
    final code = uri.queryParameters['code'];
    if (code == null) {
      return false;
    }

    // --- FIX 2: LOAD the code_verifier from storage ---
    final prefs = await SharedPreferences.getInstance();
    final codeVerifier = prefs.getString('spotify_code_verifier');

    if (codeVerifier == null) {
      print('Error: Could not find stored code_verifier.');
      return false;
    }

    try {
      final response = await http.post(
        Uri.https('accounts.spotify.com', '/api/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': _clientId,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': _redirectUri,
          'code_verifier': codeVerifier, // Use the loaded verifier
        },
      );

      // Clean up the verifier from storage after use
      await prefs.remove('spotify_code_verifier');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final accessToken = data['access_token'];
        final refreshToken = data['refresh_token'];

        // This part was already correct: it logs the token and stores it.
        print('--- SPOTIFY ACCESS TOKEN ---');
        print(accessToken);
        print('----------------------------');

        await _storeTokens(accessToken, refreshToken);
        return true; // Signal success
      } else {
        print('Failed to get token: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error exchanging code for token: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('spotify_access_token');
    await prefs.remove('spotify_refresh_token');
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('spotify_access_token');
  }

  Future<void> _storeTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('spotify_access_token', accessToken);
    await prefs.setString('spotify_refresh_token', refreshToken);
  }

  String _generateRandomString(int length) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))),
    );
  }

  String _generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }
}