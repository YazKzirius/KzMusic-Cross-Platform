import 'package:flutter/material.dart';

class MediaOverlayScreen extends StatefulWidget {
  const MediaOverlayScreen({super.key});

  @override
  State<MediaOverlayScreen> createState() => _MediaOverlayScreenState();
}

class _MediaOverlayScreenState extends State<MediaOverlayScreen> {
  double _speedValue = 1.0;
  double _pitchValue = 1.0;
  double _reverbValue = 0.0;
  double _progressValue = 0.0;

  @override
  Widget build(BuildContext context) {
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
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white),
                      onPressed: () {
                        // Handle down button press
                      },
                    ),
                    const Text(
                      'Now Playing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {
                        // Handle menu button press
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Visualizer and Album Art
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Placeholder for VisualizerView
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade800, width: 2),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                        AssetImage('assets/ic_library.png'), // Add your image asset
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Song Title
                const Text(
                  'Song Title',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Speed Slider
                Slider(
                  value: _speedValue,
                  min: 0.5,
                  max: 2.0,
                  onChanged: (value) {
                    setState(() {
                      _speedValue = value;
                    });
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                ),
                Text(
                  'Speed: ${_speedValue.toStringAsFixed(1)}x',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Pitch Slider
                Slider(
                  value: _pitchValue,
                  min: 0.5,
                  max: 2.0,
                  onChanged: (value) {
                    setState(() {
                      _pitchValue = value;
                    });
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                ),
                Text(
                  'Pitch: ${_pitchValue.toStringAsFixed(1)}x',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Reverb Slider
                Slider(
                  value: _reverbValue,
                  min: 0.0,
                  max: 100.0,
                  onChanged: (value) {
                    setState(() {
                      _reverbValue = value;
                    });
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                ),
                Text(
                  'Reverberation: ${_reverbValue.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 26),

                // Progress Bar and Playback Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            '00:00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: _progressValue,
                              onChanged: (value) {
                                setState(() {
                                  _progressValue = value;
                                });
                              },
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                            ),
                          ),
                          const Text(
                            '00:00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.loop, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.fast_rewind,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_previous,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.pause,
                                color: Colors.white, size: 40),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon:
                            const Icon(Icons.skip_next, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.fast_forward,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon:
                            const Icon(Icons.shuffle, color: Colors.white),
                            onPressed: () {},
                          ),
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