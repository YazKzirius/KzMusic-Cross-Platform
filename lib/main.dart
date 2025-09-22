import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/screens/GetStartedScreen.dart';
import 'package:kzmusic_cross_platform/screens/LandingPage.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:kzmusic_cross_platform/services/SpotifyAuthService.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kzmusic_cross_platform/services/PlatformService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kzmusic',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AuthGate()
    );
  }
}
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final SpotifyAuthService _authService = SpotifyAuthService();
  StreamSubscription<Uri>? _linkSubscription;

  bool _isLoggedIn = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initAuth() async {
    if (kIsWeb) {
      await _handleWebAuth();
    } else {
      await _handleMobileAuth();
    }
  }

  Future<void> _handleWebAuth() async {
    final currentUri = Uri.base;
    if (currentUri.queryParameters.containsKey('code')) {
      final success = await _authService.handleRedirect(currentUri);
      if (mounted) {
        setState(() {
          _isLoggedIn = success;
          _isChecking = false;
        });
        cleanUrlAfterAuth();
      }
    } else {
      final token = await _authService.getAccessToken();
      if (mounted) {
        setState(() {
          _isLoggedIn = token != null;
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _handleMobileAuth() async {
    final _appLinks = AppLinks();
    final storedToken = await _authService.getAccessToken();
    if (storedToken != null) {
      if (mounted) setState(() {
        _isLoggedIn = true;
        _isChecking = false;
      });
      return;
    }
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      await _handleAuthRedirect(initialUri);
      return;
    }
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleAuthRedirect(uri);
    });
    if (mounted) setState(() => _isChecking = false);
  }

  Future<void> _handleAuthRedirect(Uri uri) async {
    if (uri.scheme == 'kzmusiccrossplatform' && uri.host == 'callback') {
      final success = await _authService.handleRedirect(uri);
      if (success && mounted) {
        setState(() {
          _isLoggedIn = true;
          _isChecking = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _isLoggedIn ? const LandingPage() : const GetStartedScreen();
  }
}
