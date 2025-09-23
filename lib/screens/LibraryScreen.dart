import 'package:flutter/material.dart';

// This is the main widget for your 'Library' tab.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The Stack allows us to layer the scrollable content and the fixed playback bar.
    return Stack(
      children: [
        // The SingleChildScrollView makes the entire page scrollable vertically.
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align headers to the left
              children: [
                InkWell(
                  onTap: () => print('Local Library Tapped'),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/ic_library.png', // TODO: Add icon
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Local Library',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 112), // Align with text above
                  child: Text(
                    'No Tracks',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Playlist Section ---
                const Text(
                  'Local Playlists',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // "Create playlist" button
                    _CreatePlaylistButton(),
                    const SizedBox(width: 16),
                    // Horizontal list of playlists
                    _PlaylistListView(),
                  ],
                ),
                const SizedBox(height: 24),

                // --- History Section ---
                const Text(
                  'Playing History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _HistoryListView(),

                // This padding ensures the last item can scroll up above the playback bar.
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The "Create playlist" button widget.
class _CreatePlaylistButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print('Create Playlist Tapped'),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            color: const Color(0xFF0A0A0A), // Match background
            child: const Icon(Icons.add, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 4),
          const Text(
            'Create playlist',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// The horizontal list for playlists.
class _PlaylistListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Expanded makes this ListView take up the remaining horizontal space in the Row.
    return Expanded(
      child: SizedBox(
        height: 180, // Fixed height for the horizontal list
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5, // Dummy data
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    color: Colors.grey[800],
                    child: const Icon(Icons.music_note, color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Playlist ${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The vertical list for playing history.
class _HistoryListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10, // Dummy data
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.history, color: Colors.white),
          title: Text('History Item ${index + 1}', style: const TextStyle(color: Colors.white)),
          subtitle: Text('Artist Name', style: TextStyle(color: Colors.grey[400])),
          onTap: () {},
        );
      },
    );
  }
}