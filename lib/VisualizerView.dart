import 'package:flutter/material.dart';
import 'dart:math';

class VisualizerView extends StatelessWidget {
  final List<double> fftData;

  const VisualizerView({super.key, required this.fftData});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VisualizerPainter(fftData),
      child: Container(),
    );
  }
}

class _VisualizerPainter extends CustomPainter {
  final List<double> fftData;
  final Paint _paint = Paint();

  _VisualizerPainter(this.fftData) {
    _paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (fftData.isEmpty) return;

    final width = size.width;
    final height = size.height;
    final centerY = height / 2;
    final barWidth = width / fftData.length;

    for (int i = 0; i < fftData.length; i++) {
      final double magnitude = fftData[i] * height;
      final double x = i * barWidth;
      canvas.drawLine(
        Offset(x, centerY),
        Offset(x, centerY - magnitude),
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}