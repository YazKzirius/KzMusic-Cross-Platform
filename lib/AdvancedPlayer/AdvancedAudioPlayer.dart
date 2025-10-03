import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:kzmusic_cross_platform/models/MusicFile.dart';

class AdvancedAudioPlayer extends ChangeNotifier {
  final SoLoud _soLoud = SoLoud.instance;
  AudioSource? _audioSource;
  SoundHandle? _soundHandle;

  // Private state variables
  List<MusicFile> _playlist = [];
  int _currentIndex = -1;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Timer? _positionTimer;

  // Public getters for the UI to read the state
  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  MusicFile? get currentSong => _currentIndex != -1 ? _playlist[_currentIndex] : null;
  double _speed = 1.0;
  double _pitch = 1.0;
  double _reverb = 0.0;

  double get speed => _speed;
  double get pitch => _pitch;
  double get reverb => _reverb;

  Future<void> init() async {
    // Only initialize if not already done
    if (!_soLoud.isInitialized) {
      print("[AUDIO DEBUG] SoLoud is not initialized. Attempting to init...");
      try {
        await _soLoud.init();
        print("[AUDIO DEBUG] SoLoud engine initialized successfully on demand.");
      } catch (e) {
        print("[AUDIO DEBUG] !!! SoLoud FAILED to initialize on demand: $e");
      }
    } else {
      print("[AUDIO DEBUG] SoLoud was already initialized.");
    }
  }

  Future<void> playSong(List<MusicFile> playlist, int startIndex) async {
    print("[AUDIO DEBUG] playSong called for index $startIndex.");
    await init();
    if (!_soLoud.isInitialized) {
      print("[AUDIO DEBUG] !!! CANNOT PLAY: SoLoud is still not initialized after init() call.");
      return;
    }

    _playlist = playlist;
    await _loadAndPlay(startIndex);
  }

  Future<void> _loadAndPlay(int index) async {
    print("[AUDIO DEBUG] _loadAndPlay called for index $index.");
    if (index < 0 || index >= _playlist.length) {
      print("[AUDIO DEBUG] Invalid index, aborting.");
      return;
    }
    _currentIndex = index;

    if (_soundHandle != null) await _soLoud.stop(_soundHandle!);
    if (_audioSource != null) await _soLoud.disposeSource(_audioSource!);
    _positionTimer?.cancel();
    _currentPosition = Duration.zero;
    notifyListeners();

    try {
      final musicFile = _playlist[_currentIndex];
      print("[AUDIO DEBUG] Attempting to load file: ${musicFile.path!}");
      _audioSource = await SoLoud.instance.loadFile(musicFile.path!)
          .timeout(const Duration(seconds: 5), onTimeout: () {
        // This is the correct way to handle a timeout.
        throw TimeoutException('File loading timed out for ${musicFile.path!}');
      });

      if (_audioSource == null) {
        // This will now only catch cases where loadFile legitimately returns null.
        print("[AUDIO DEBUG] !!! loadFile returned null. The file might be corrupt or unsupported.");
        _isPlaying = false;
        notifyListeners();
        return;
      }

      print("[AUDIO DEBUG] File loaded successfully. Now playing...");
      _soundHandle = await _soLoud.play(_audioSource!);
      _totalDuration = _soLoud.getLength(_audioSource!);
      _isPlaying = true;
      print("[AUDIO DEBUG] Play command issued. Duration: $_totalDuration. IsPlaying: $_isPlaying");

      _startPositionTimer();
      notifyListeners();

    } catch (e) {
      print("[AUDIO DEBUG] !!! ERROR in _loadAndPlay: $e");
      _isPlaying = false;
      notifyListeners(); // Notify UI that playback failed
    }
  }

  void togglePlayPause() {
    if (_soundHandle != null) {
      final wasPlaying = _isPlaying;
      SoLoud.instance.pauseSwitch(_soundHandle!);
      _isPlaying = !wasPlaying;

      if (_isPlaying) {
        _startPositionTimer();
      } else {
        _positionTimer?.cancel();
      }
      notifyListeners();
    }
  }

  void skipNext() {
    int nextIndex = (_currentIndex + 1) % _playlist.length;
    _loadAndPlay(nextIndex);
  }

  void skipPrevious() {
    int prevIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    _loadAndPlay(prevIndex);
  }

  void seek(Duration position) {
    if (_soundHandle != null) {
      _soLoud.seek(_soundHandle!, position);
      _currentPosition = position;
      notifyListeners(); // Immediately update UI for better responsiveness
    }
  }
  void setSpeed(double value) {
    _speed = value;
    notifyListeners();
  }

  void setPitch(double value) {
    _pitch = value;
    notifyListeners();
  }

  void setReverb(double value) {
    _reverb = value;
    notifyListeners();
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (!_isPlaying || _soundHandle == null) {
        timer.cancel();
        return;
      }

      if (!await _soLoud.getIsValidVoiceHandle(_soundHandle!)) {
        _isPlaying = false;
        _currentPosition = _totalDuration;
        timer.cancel();
        notifyListeners();
        skipNext();
      } else {
        _currentPosition = await _soLoud.getPosition(_soundHandle!);
        notifyListeners();
      }
    });
  }



  @override
  void dispose() {
    _positionTimer?.cancel();
    _soLoud.disposeAllSources();
    super.dispose();
  }
}