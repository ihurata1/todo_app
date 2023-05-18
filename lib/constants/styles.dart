import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:root/constants/colors.dart';

import '../helpers/theme_services.dart';

class AppTextStyle {
  static TextStyle get subHeadingStyle {
    return GoogleFonts.lato(
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColor.lessDarkBlue,
      ),
    );
  }

  static TextStyle get subOptionStyle {
    return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: ThemeService().theme == ThemeMode.light ? AppColor.black30 : AppColor.white,
      ),
    );
  }

  static TextStyle get headerStyle {
    return GoogleFonts.lato(
      textStyle: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static TextStyle get dateTextStyle {
    return GoogleFonts.lato(
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  static TextStyle get titleStyle {
    return GoogleFonts.lato(
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static TextStyle get subTitleStyle {
    return GoogleFonts.lato(
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static TextStyle get hintStyle {
    return GoogleFonts.lato(
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static TextStyle get dayTextStyle {
    return GoogleFonts.lato(
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  static TextStyle get monthTextStyle {
    return GoogleFonts.lato(
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }
}
