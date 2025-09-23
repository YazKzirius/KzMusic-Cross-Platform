import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _DashboardScreenState();
  }
}
class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main scrollable content
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _DashboardItem(
                  iconPath: 'assets/ic_radio.png', // TODO: Add icon to assets
                  label: 'Your Radio',
                  onTap: () {
                    print('Your Radio tapped');
                  },
                ),
                _DashboardItem(
                  iconPath: 'assets/ic_for_you.png', // TODO: Add icon to assets
                  label: 'Made for You',
                  onTap: () {
                    print('Made for You tapped');
                  },
                ),
                _DashboardItem(
                  iconPath: 'assets/ic_podium.png', // TODO: Add icon to assets
                  label: 'Your Top 100',
                  onTap: () {
                    print('Top 100 tapped');
                  },
                ),
                _DashboardItem(
                  iconPath: 'assets/ic_favourite.png', // TODO: Add icon to assets
                  label: 'Saved Songs',
                  onTap: () {
                    print('Saved Songs tapped');
                  },
                ),
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
/// A reusable widget for the interactive items in the list.
class _DashboardItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const _DashboardItem({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            // Icon
            Image.asset(
              iconPath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 20),
            // Label (takes up remaining space)
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
