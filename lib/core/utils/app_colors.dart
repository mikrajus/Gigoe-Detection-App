import 'package:flutter/material.dart';

class AppColors {
  static const Color softWhite = Color(0xFFF5EEF8); // Soft Purple White
  static const Color softBlue = Color(0xFFD7BDE2); // Soft Purple
  static const Color primaryBlue = Color(0xFF8E44AD); // Primary Purple
  static const Color darkBlue = Color(0xFF4A235A); // Dark Purple

  // --- New Premium Aesthetic Tokens ---
  static const Gradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF8E44AD),
      Color(0xFF6C3483),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 20,
      offset: const Offset(0, 10),
      spreadRadius: 0,
    )
  ];
}
