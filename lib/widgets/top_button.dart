import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final Map<String, dynamic> colors;
  final double borderRadius;

  const TopButton({
    super.key,
    this.icon,
    this.label,
    required this.colors,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withAlpha(20)),
        boxShadow: [
          BoxShadow(
            color: colors["shadowColor"],
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, color: colors["primaryColor"], size: 18),
          if (label != null) ...[
            if (icon != null) const SizedBox(width: 6),
            Text(
              label!,
              style: GoogleFonts.inter(
                color: colors["primaryColor"],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
