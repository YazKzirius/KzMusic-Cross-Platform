import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/services/SpotifyAuthService.dart';
import 'package:kzmusic_cross_platform/screens/DashboardScreen.dart';

// Placeholder screens for the navigation items
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context) => const DashboardScreen();
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Search'));
}

class GenAIScreen extends StatelessWidget {
  const GenAIScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('GenAI'));
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Library'));
}

// Settings screen with a sign-out button
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Note: This is a simplified sign-out. In a real app, you'd use a
          // state management solution to notify the app of the state change.
          // For this prototype, we'll just call the service.
          SpotifyAuthService().signOut();
          print("User signed out. Please restart the app to see the login screen.");
        },
        child: const Text('Sign Out'),
      ),
    );
  }
}


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DashboardScreen(),
    SearchScreen(),
    GenAIScreen(),
    LibraryScreen(),
    SettingsScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'GenAI'),
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