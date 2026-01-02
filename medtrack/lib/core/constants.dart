import 'package:flutter/material.dart';
import 'app_colors.dart';

class MedConstants {
  // Spacing
  static const double padding = 20.0;
  static const double borderRadius = 12.0;

  // Text Styles (Following Roboto as per SRS)
  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: MedColors.textMain,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: MedColors.textMain,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: MedColors.textSecondary,
  );

  static const TextStyle labelText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.grey,
    letterSpacing: 0.5,
  );
}
