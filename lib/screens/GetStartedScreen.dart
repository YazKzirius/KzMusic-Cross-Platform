import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/services/SpotifyAuthService.dart';
import 'package:kzmusic_cross_platform/screens/LandingPage.dart';


class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  bool _isLoading = false;
  final SpotifyAuthService _authService = SpotifyAuthService();
  void _handleGetStarted() async {
    setState(() {
      _isLoading = true;
    });

    // This will open the browser for the user to log in.
    // The redirect will be handled when the app comes back into focus.
    await _authService.authenticate();

    // We don't need to handle success/failure here, as the redirect
    // will trigger a full app reload on the web.
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Equivalent to #0A0A0A
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 64.0), // Equivalent to marginTop="64dp"

                // App Logo
                Image.asset(
                  'assets/AppLogo.png', // Make sure to add your logo to the assets folder
                  width: 180.0,
                  height: 180.0,
                ),

                const SizedBox(height: 48.0), // Equivalent to marginTop="48dp"

                // Get Started Button
                SizedBox(
                  width: double.infinity, // Equivalent to layout_width="0dp" with constraints
                  height: 56.0,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleGetStarted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6200EE), // Equivalent to backgroundTint="@color/purple"
                      foregroundColor: Colors.white,   // Equivalent to textColor="@android:color/white"
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    child: const Text('Get Started'),
                  ),
                ),
                const SizedBox(height: 28.0),
                SizedBox(
                  width: double.infinity, // Equivalent to layout_width="0dp" with constraints
                  height: 56.0,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LandingPage())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF222222), // Equivalent to backgroundTint="@color/purple"
                      foregroundColor: Colors.white,   // Equivalent to textColor="@android:color/white"
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    child: const Text('Use Offline'),
                  ),
                ),

                // Loading Spinner / ProgressBar
                if (_isLoading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6200EE)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}