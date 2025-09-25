/// A data model class that represents a single music file.
class MusicFile {
  /// A unique identifier for the music file, often from the device's media store.
  final int id;

  /// The display name or title of the track.
  final String name;

  /// The name of the artist.
  final String artist;

  /// The absolute file path to the audio file on the device.
  final String path;

  /// The unique identifier for the album this track belongs to.
  final int albumId;

  /// All parameters are required.
  MusicFile({
    required this.id,
    required this.name,
    required this.artist,
    required this.path,
    required this.albumId,
  });
  factory MusicFile.fromJson(Map<String, dynamic> json) {
    return MusicFile(
      id: json['id'] as int,
      name: json['name'] as String,
      artist: json['artist'] as String,
      path: json['path'] as String,
      albumId: json['albumId'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'artist': artist,
      'path': path,
      'albumId': albumId,
    };
  }
}