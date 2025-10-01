import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/screens/GetStartedScreen.dart';
import 'package:kzmusic_cross_platform/services/SpotifyAuthService.dart'; // Make sure this path is correct
import 'package:provider/provider.dart';
import 'package:kzmusic_cross_platform/services/AuthNotifier.dart'; // Import the notifier';

// This is the main widget for your 'Settings' tab.
class OfflineSettingsScreen extends StatelessWidget {
  const OfflineSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView makes the content scrollable if it overflows.
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center aligns children horizontally to the center.
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            // Using CircleAvatar for a circular shape, which is common for profile pics.
            const CircleAvatar(
              radius: 48, // Corresponds to 96dp width/height
              backgroundColor: Colors.transparent,
              // TODO: Replace with your account icon asset
              child: Icon(Icons.account_circle, size: 96, color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Username Display
            const Text(
              'Welcome, Yazeed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Divider
            const Divider(color: Colors.grey),
            const SizedBox(height: 24),

            // Connect with Spotify Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(8), // For the rounded_background effect
              ),
              child: Row(
                children: [
                  // Spotify Icon
                  Image.asset(
                    'assets/ic_spotify.png', // TODO: Add Spotify icon to assets
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 12),
                  // Expanded makes the button take up the remaining space
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Navigating to back to homepage')),
                        );
                        Provider.of<AuthNotifier>(context, listen: false).signOut();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Go online with Spotify', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}