import 'dart:typed_data';

class MusicFile {
  final String path;
  final String title;
  final String artist;
  final Uint8List? albumArt;

  MusicFile({
    required this.path,
    required this.title,
    required this.artist,
    this.albumArt,
  });
}