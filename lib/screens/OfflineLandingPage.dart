import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/services/SpotifyAuthService.dart';
import 'package:kzmusic_cross_platform/screens/OfflineDashboardScreen.dart';
import 'package:kzmusic_cross_platform/screens/LibraryScreen.dart';
import 'package:kzmusic_cross_platform/screens/OfflineSettingsScreen.dart';

// Placeholder screens for the navigation items
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context) => const OfflineDashboardScreen();
}

class Library extends StatelessWidget {
  const Library({super.key});
  @override
  Widget build(BuildContext context) => const LibraryScreen();
}

// Settings screen with a sign-out button
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) => const OfflineSettingsScreen();
}


class OfflineLandingPage extends StatefulWidget {
  const OfflineLandingPage({super.key});

  @override
  State<OfflineLandingPage> createState() => _OfflineLandingPageState();
}

class _OfflineLandingPageState extends State<OfflineLandingPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Dashboard(),
    Library(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Image.asset(
              'assets/AppLogo.png', // The single, shared logo
              width: 120,
              height: 120,
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),

          const PlaybackBar(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF6200EE),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
class PlaybackBar extends StatelessWidget {
  const PlaybackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: const Color(0xFF111111), // Dark background
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              'assets/ic_library.png',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Untitled',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Unknown Artist',
                  style: const TextStyle(
                    color: Color(0xFFCCCCCC),
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
            onPressed: () => print('Playback bar tapped'),
          ),
        ],
      ),
    );
  }
}