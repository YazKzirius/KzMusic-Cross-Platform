import 'package:kzmusic_cross_platform/models/MusicFile.dart'; // Make sure this import is correct for your project

class SongQueue {
  static final SongQueue _instance = SongQueue._internal();

  factory SongQueue() {
    return _instance;
  }

  SongQueue._internal();

  List<MusicFile> songList = [];
  List<MusicFile> songsPlayed = [];
  List<MusicFile> history = [];
  MusicFile? currentSong;
  int currentPosition = -1;
  double speed = 1.0;
  double pitch = 1.0;
  double reverb = 0.0;
  bool isLooping = false;
  bool shuffleOn = false;
  int pointer = 0;
  String currentPlaylist = "";
  String playingPlaylist = "";

  void addSong(MusicFile song) {
    songsPlayed.add(song);
    currentSong = song;
    pointer++;
  }

  void updateHistory(MusicFile song) {
    history.add(song);
  }

  void setSongList(List<MusicFile> list) {
    songList = list;
  }

  void setPosition(int pos) {
    currentPosition = pos;
  }

  void setSpeed(double newSpeed) {
    speed = newSpeed;
  }

  void setPitch(double newPitch) {
    pitch = newPitch;
  }

  void setReverbLevel(double reverbLevel) {
    reverb = reverbLevel;
  }

  void setIsLooping(bool looping) {
    isLooping = looping;
  }

  void setShuffleOn(bool shuffle) {
    shuffleOn = shuffle;
  }

  void setPlayingPlaylist(String playlist) {
    playingPlaylist = playlist;
  }

  void setCurrentPlaylist(String playlist) {
    currentPlaylist = playlist;
  }

  void resetToDefaults() {
    songList = [];
    songsPlayed.clear();
    currentSong = null;
    currentPosition = -1;
    speed = 1.0;
    pitch = 1.0;
    reverb = 0.0;
    isLooping = false;
    shuffleOn = false;
    pointer = 0;
    currentPlaylist = "";
    playingPlaylist = "";
  }
}