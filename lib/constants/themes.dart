import 'package:flutter/material.dart';
import 'package:root/constants/colors.dart';

class AppThemes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColor.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.white,
    ),
    scaffoldBackgroundColor: AppColor.white,
  );
  static final dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColor.black30,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.black30,
    ),
  );
}
