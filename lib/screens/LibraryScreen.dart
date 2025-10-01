import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/models/MusicFile.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:permission_handler/permission_handler.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool _isShowingLocalLibrary = false;
  bool _isLoading = false;
  List<MusicFile> _musicFiles = [];
  PermissionStatus? _permissionStatus;
  void _showLocalLibraryView() {
    setState(() {
      _isShowingLocalLibrary = true;
    });
    _checkInitialPermission();
  }

  void _showMainLibraryView() {
    setState(() {
      _isShowingLocalLibrary = false;
    });
  }

  /// Checks the current permission status when the screen is first shown.
  Future<void> _checkInitialPermission() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;

    final permission = Platform.isAndroid ? Permission.audio : Permission.mediaLibrary;
    final status = await permission.status;
    if(mounted) setState(() => _permissionStatus = status);
  }

  /// Master function to trigger the permission request and file scan.
  Future<void> requestPermissionAndScan() async {
    setState(() => _isLoading = true);

    List<MusicFile> loadedFiles = [];
    try {
      if (kIsWeb) {
        loadedFiles = await _loadFromWeb();
      } else if (Platform.isAndroid || Platform.isIOS) {
        loadedFiles = await _loadFromMobile();
      } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        loadedFiles = await _loadFromDesktop();
      }
    } catch (e) {
      print("An error occurred during scanning: $e");
    }

    if(mounted) {
      setState(() {
        _musicFiles = loadedFiles;
        _isLoading = false;
      });
    }
  }

  /// Handles logic specifically for Mobile, with explicit permission requests.
  Future<List<MusicFile>> _loadFromMobile() async {
    final OnAudioQuery audioQuery = OnAudioQuery();
    List<MusicFile> files = [];

    final permission = Platform.isAndroid ? Permission.audio : Permission.mediaLibrary;
    var status = await permission.request();

    if(mounted) setState(() => _permissionStatus = status);
    if (!status.isGranted) return [];

    List<SongModel> songs = await audioQuery.querySongs(uriType: UriType.EXTERNAL);
    for (var song in songs) {
      if (song.isMusic == true) {
        Uint8List? artwork = await audioQuery.queryArtwork(song.id, ArtworkType.AUDIO);
        files.add(MusicFile(path: song.data, title: song.title, artist: song.artist ?? "Unknown Artist", albumArt: artwork));
      }
    }
    return files;
  }

  /// MODIFIED: Handles the web-specific flow with proper error handling.
  Future<List<MusicFile>> _loadFromWeb() async {
    final OnAudioQuery audioQuery = OnAudioQuery();
    List<MusicFile> files = [];
    try {
      List<SongModel> songs = await audioQuery.querySongs(uriType: UriType.EXTERNAL);
      for (var song in songs) {
        if (song.isMusic == true) {
          Uint8List? artwork = await audioQuery.queryArtwork(song.id, ArtworkType.AUDIO);
          files.add(MusicFile(path: song.data, title: song.title, artist: song.artist ?? "Unknown Artist", albumArt: artwork));
        }
      }
    } catch (e) {
      print("Error during web file picking: $e");
    }
    return files;
  }


  /// Handles logic for Desktop, where the file picker IS the permission request.
  Future<List<MusicFile>> _loadFromDesktop() async {
    List<MusicFile> files = [];
    String? dirPath = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Please select your music folder');
    if (dirPath == null) return [];

    final dir = Directory(dirPath);
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && (entity.path.endsWith('.mp3') || entity.path.endsWith('.m4a') || entity.path.endsWith('.flac'))) {
        try {
          final metadata = await readMetadata(entity);
          files.add(MusicFile(
            path: entity.path,
            title: metadata.title ?? "Unknown Title",
            artist: metadata.artist ?? "Unknown Artist",
            albumArt: metadata.pictures.isNotEmpty ? metadata.pictures.first.bytes : null,
          ));
        } catch (e) {
          print("Error reading metadata for ${entity.path}: $e");
        }
      }
    }
    return files;
  }

  @override
  Widget build(BuildContext context) {
    if (_isShowingLocalLibrary) {
      return _buildLocalLibraryContent();
    } else {
      return _buildMainLibraryContent();
    }
  }

  /// This widget now handles all UI states: Initial, Loading, Denied, and Success.
  Widget _buildLocalLibraryContent() {
    Widget bodyContent;

    if (_isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    }
    else if (_permissionStatus != null && _permissionStatus!.isPermanentlyDenied) {
      bodyContent = _buildPermissionUI(
        icon: Icons.gpp_bad_outlined,
        title: 'Permission Required',
        message: 'You have permanently denied media access. To scan for music, you must enable this permission in your device settings.',
        buttonText: 'Open App Settings',
        onPressed: openAppSettings,
      );
    }
    else if (_permissionStatus != null && _permissionStatus!.isDenied) {
      bodyContent = _buildPermissionUI(
        icon: Icons.error_outline,
        title: 'Permission Needed',
        message: 'Kzmusic needs access to your media files to find and play your local music.',
        buttonText: 'Grant Permission',
        onPressed: requestPermissionAndScan,
      );
    }
    else if (_musicFiles.isEmpty) {
      bodyContent = _buildInitialScanUI();
    } else {
      bodyContent = GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0, childAspectRatio: 0.7),
        itemCount: _musicFiles.length,
        itemBuilder: (context, index) {
          final file = _musicFiles[index];
          return GridTile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[800],
                    width: double.infinity,
                    child: file.albumArt != null ? Image.memory(file.albumArt!, fit: BoxFit.cover) : const Icon(Icons.music_note, color: Colors.white, size: 50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(file.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(file.artist, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), onPressed: _showMainLibraryView),
        title: const Text('Kzirius Local library', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: bodyContent,
    );
  }

  /// MODIFIED: A new helper to show the correct initial prompt based on platform.
  Widget _buildInitialScanUI() {
    String message = '';
    String buttonText = '';
    IconData icon = Icons.music_note;

    if (kIsWeb) {
      message = 'Select music files from your computer to begin.';
      buttonText = 'Select Files';
      icon = Icons.cloud_upload_outlined;
    } else if (Platform.isAndroid || Platform.isIOS) {
      message = 'Find all the local music on your device.';
      buttonText = 'Scan for Music';
      icon = Icons.search;
    } else { // Desktop
      message = 'Select a folder to scan for your local music.';
      buttonText = 'Select Music Folder';
      icon = Icons.folder_open;
    }

    return _buildPermissionUI(
      icon: icon,
      title: 'Your Local Library',
      message: message,
      buttonText: buttonText,
      onPressed: requestPermissionAndScan,
    );
  }

  Widget _buildPermissionUI({required IconData icon, required String title, required String message, required String buttonText, required VoidCallback onPressed}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white54, size: 60),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(message, style: TextStyle(color: Colors.white.withOpacity(0.7)), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onPressed, child: Text(buttonText))
          ],
        ),
      ),
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
              child: Row(children: [Image.asset('assets/ic_library.png', width: 100, height: 100), const SizedBox(width: 12), const Text('Local Library', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]),
            ),
            const SizedBox(height: 6),
            Padding(padding: const EdgeInsets.only(left: 112), child: Text('${_musicFiles.length} Tracks', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16))),
            const SizedBox(height: 24),
            const Text('Local Playlists', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(children: [_CreatePlaylistButton(), const SizedBox(width: 16), _PlaylistListView()]),
            const SizedBox(height: 24),
            const Text('Playing History', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _HistoryListView(),
          ],
        ),
      ),
    );
  }
}

class _CreatePlaylistButton extends StatelessWidget {@override Widget build(BuildContext context) => InkWell(onTap: () => print('Create Playlist Tapped'), child: Column(children: [Container(width: 90, height: 90, color: const Color(0xFF0A0A0A), child: const Icon(Icons.add, color: Colors.white, size: 40)), const SizedBox(height: 4), const Text('Create playlist', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]));}
class _PlaylistListView extends StatelessWidget {@override Widget build(BuildContext context) => Expanded(child: SizedBox(height: 180, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: 5, itemBuilder: (context, index) => Padding(padding: const EdgeInsets.only(right: 12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 140, height: 140, color: Colors.grey[800], child: const Icon(Icons.music_note, color: Colors.white, size: 50)), const SizedBox(height: 4), Text('Playlist ${index + 1}', style: const TextStyle(color: Colors.white))])))));}
class _HistoryListView extends StatelessWidget {@override Widget build(BuildContext context) => ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: 10, itemBuilder: (context, index) => ListTile(leading: const Icon(Icons.history, color: Colors.white), title: Text('History Item ${index + 1}', style: const TextStyle(color: Colors.white)), subtitle: Text('Artist Name', style: TextStyle(color: Colors.grey[400])), onTap: () {}));}
