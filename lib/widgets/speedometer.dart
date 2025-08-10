import 'package:flutter/material.dart';
import 'package:speedometer_chart/speedometer_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class Speedometer extends StatelessWidget {
  final double size;
  final int score;
  final Map<String, dynamic> colors;

  const Speedometer({
    super.key,
    required this.size,
    required this.score,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedometerChart(
      dimension: size,
      minValue: 0,
      maxValue: 100,
      value: score.toDouble(),
      graphColor: List<Color>.from(colors["speedometerColors"]),
      pointerColor: colors["pointerColor"],
      valueWidget: Text(
        "$score / 100",
        style: GoogleFonts.inter(
          fontSize: size * 0.08,
          fontWeight: FontWeight.w600,
          color: colors["primaryColor"],
        ),
      ),
    );
  }
}
