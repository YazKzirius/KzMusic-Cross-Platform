import 'package:flutter/material.dart';

class OfflineDashboardScreen extends StatefulWidget {
  const OfflineDashboardScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _OfflineDashboardScreenState();
  }
}
class _OfflineDashboardScreenState extends State<OfflineDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Column(
        children: [Text('Offline Dashboard')
        ]
    )
    );
  }
}