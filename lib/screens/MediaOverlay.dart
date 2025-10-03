import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/models/MusicFile.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kzmusic_cross_platform/models/SongQueue.dart';
import 'package:kzmusic_cross_platform/AdvancedPlayer/AdvancedAudioPlayer.dart';
import 'package:provider/provider.dart';

class MediaOverlayScreen extends StatefulWidget {
  final MusicFile musicFile;
  final List<MusicFile> musicFiles;
  final int position;

  const MediaOverlayScreen({
    super.key,
    required this.musicFile,
    required this.musicFiles,
    required this.position,
  });
  @override
  State<MediaOverlayScreen> createState() => _MediaOverlayScreenState();
}

class _MediaOverlayScreenState extends State<MediaOverlayScreen> {
  double _speedValue = 1.0;
  double _pitchValue = 1.0;
  double _reverbValue = 0.0;
  double _progressValue = 0.0;
  final SoLoud _soLoud = SoLoud.instance;
  final SongQueue _songQueue = SongQueue();
  late MusicFile _currentMusicFile;
  late int _currentPosition;

  @override
  void initState() {
    super.initState();
    final audioPlayer = context.read<AdvancedAudioPlayer>();
    audioPlayer.playSong(widget.musicFiles, widget.position);

  }
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  @override
  Widget build(BuildContext context) {
    final audioPlayer = context.watch<AdvancedAudioPlayer>();

    // Get current state from the player
    final currentSong = audioPlayer.currentSong;
    final isPlaying = audioPlayer.isPlaying;
    final currentPosition = audioPlayer.currentPosition;
    final totalDuration = audioPlayer.totalDuration;
    final sliderPosition = currentPosition.inSeconds.toDouble().clamp(
      0.0,
      totalDuration.inSeconds > 0 ? totalDuration.inSeconds.toDouble() : 1.0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Now Playing', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Visualizer and Album Art (UI only)
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade800, width: 2),
                        ),
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: currentSong?.albumArt != null
                            ? MemoryImage(currentSong!.albumArt!)
                            : const AssetImage('assets/ic_library.png') as ImageProvider,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Song Title (Reads from player)
                Text(
                  currentSong?.title ?? 'No song selected',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  currentSong?.artist ?? '',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                const SizedBox(height: 30),
                _buildEffectSlider(
                  label: 'Speed',
                  value: audioPlayer.speed,
                  displayValue: '${audioPlayer.speed.toStringAsFixed(1)}x',
                  min: 0.5, max: 2.0, divisions: 15,
                  onChanged: (value) => audioPlayer.setSpeed(value),
                ),
                const SizedBox(height: 10),
                _buildEffectSlider(
                  label: 'Pitch',
                  value: audioPlayer.pitch,
                  displayValue: '${audioPlayer.pitch.toStringAsFixed(1)}x',
                  min: 0.5, max: 2.0, divisions: 15,
                  onChanged: (value) => audioPlayer.setPitch(value),
                ),
                const SizedBox(height: 10),
                _buildEffectSlider(
                  label: 'Reverberation',
                  value: audioPlayer.reverb,
                  displayValue: '${audioPlayer.reverb.toInt()}%',
                  min: 0, max: 100, divisions: 100,
                  onChanged: (value) => audioPlayer.setReverb(value),
                ),
                const SizedBox(height: 26),
                // Progress Bar and Playback Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(_formatDuration(currentPosition), style: const TextStyle(color: Colors.white)),
                          Expanded(
                            child: Slider(
                              value: sliderPosition, // Use the safe clamped value
                              max: totalDuration.inSeconds > 0 ? totalDuration.inSeconds.toDouble() : 1.0,
                              onChanged: (value) { /* UI can update visually while dragging if needed */ },
                              onChangeEnd: (value) => audioPlayer.seek(Duration(seconds: value.toInt())),
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                            ),
                          ),
                          Text(_formatDuration(totalDuration), style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(icon: const Icon(Icons.loop, color: Colors.white), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.skip_previous, color: Colors.white), onPressed: audioPlayer.skipPrevious),
                          IconButton(
                            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 40),
                            onPressed: audioPlayer.togglePlayPause,
                          ),
                          IconButton(icon: const Icon(Icons.skip_next, color: Colors.white), onPressed: audioPlayer.skipNext),
                          IconButton(icon: const Icon(Icons.shuffle, color: Colors.white), onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
Widget _buildEffectSlider({
  required String label,
  required double value,
  required String displayValue,
  required double min,
  required double max,
  required int divisions,
  required ValueChanged<double> onChanged,
}) {
  return Column(
    children: [
      Text(
        '$label: $displayValue',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
        activeColor: Colors.white,
        inactiveColor: Colors.grey.shade700,
      ),
    ],
  );
}