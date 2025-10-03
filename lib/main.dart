import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/screens/GetStartedScreen.dart';
import 'package:kzmusic_cross_platform/screens/OnlineLandingPage.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:kzmusic_cross_platform/services/SpotifyAuthService.dart';
import 'package:kzmusic_cross_platform/services/AuthNotifier.dart'; // Import the notifier
import 'package:provider/provider.dart'; // Import provider
import 'package:kzmusic_cross_platform/screens/OfflineLandingPage.dart';
import 'package:kzmusic_cross_platform/AdvancedPlayer/AdvancedAudioPlayer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audioPlayer = AdvancedAudioPlayer();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: audioPlayer),
        ChangeNotifierProvider(create: (context) => AuthNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kzmusic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinkListener() async {
    final _appLinks = AppLinks();
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      authNotifier.handleAuthRedirect(initialUri);
    }

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      authNotifier.handleAuthRedirect(uri);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);
    switch (authNotifier.status) {
      case AppStatus.checking:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AppStatus.loggedIn:
        return const LandingPage();
      case AppStatus.loggedOut:
        return const GetStartedScreen();
      case AppStatus.offline:
        return const OfflineLandingPage();
    }
  }
}
