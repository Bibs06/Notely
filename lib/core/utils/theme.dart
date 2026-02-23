import 'package:flutter/material.dart';
import 'package:notely/core/utils/colors.dart';

class CustomTheme {
  static ThemeData get theme  {
    return ThemeData(
      splashColor: Colors.transparent,
      scaffoldBackgroundColor: AppColors.primaryBg,
      splashFactory: NoSplash.splashFactory,
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.darkBlue,
        iconTheme: IconThemeData(
          color: AppColors.white
        ),

        elevation: 0,
        titleSpacing: 0
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white

      ),
      
    );
  }
}