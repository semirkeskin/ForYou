import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.2,
      );

  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.3,
      );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.35,
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      );

  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: AppColors.text,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.text,
        height: 1.5,
      );

  static TextStyle get bodyMuted => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedText,
        height: 1.5,
      );

  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.2,
      );
}
