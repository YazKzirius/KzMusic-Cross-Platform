import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/models/MusicFile.dart';


class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool _isShowingLocalLibrary = false;
  void _showLocalLibraryView() {
    setState(() {
      _isShowingLocalLibrary = true;
    });
  }
  void _showMainLibraryView() {
    setState(() {
      _isShowingLocalLibrary = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isShowingLocalLibrary) {
      return _buildLocalLibraryContent();
    } else {
      return _buildMainLibraryContent();
    }
  }

  Widget _buildLocalLibraryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton.icon(
            onPressed: _showMainLibraryView,
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
            label: const Text(
              'Library',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Local Library')
          ),
        ),
      ],
    );
  }
  Widget _buildMainLibraryContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _showLocalLibraryView,
              child: Row(
                children: [
                  Image.asset(
                    'assets/ic_library.png',
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
              padding: const EdgeInsets.only(left: 112),
              child: Text(
                'No Tracks',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
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
                _CreatePlaylistButton(),
                const SizedBox(width: 16),
                _PlaylistListView(),
              ],
            ),
            const SizedBox(height: 24),
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
          ],
        ),
      ),
    );
  }
}

// The helper widgets below remain unchanged.
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
            color: const Color(0xFF0A0A0A),
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

class _PlaylistListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
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

class _HistoryListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
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
