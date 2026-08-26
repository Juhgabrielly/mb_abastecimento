import 'package:flutter/material.dart';
import 'pallet.dart';

abstract class AppTheme {
  static ThemeData appTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.p1,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.p4,
      iconTheme: IconThemeData(
        color: AppColors.p1,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.p1,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    textTheme: const TextTheme(
      titleMedium: TextStyle(
        color: AppColors.p4,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: AppColors.p4,
        fontSize: 14,
      ),
      labelMedium: TextStyle(
        color: AppColors.p4,
        fontSize: 16,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor:
            const WidgetStatePropertyAll(AppColors.p1),

        backgroundColor: WidgetStateProperty.fromMap({
          WidgetState.pressed: AppColors.p4,
          WidgetState.hovered: AppColors.p2,
          WidgetState.disabled: AppColors.t1,
          WidgetState.any: AppColors.p3,
        }),

        elevation:
            const WidgetStatePropertyAll(8.0),
      ),
    ),

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: AppColors.p3,
      foregroundColor: AppColors.p1,
    ),

    canvasColor: AppColors.p2,
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF1F2421),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF17201B),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    textTheme: const TextTheme(
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      labelMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor:
            const WidgetStatePropertyAll(Colors.white),

        backgroundColor: WidgetStateProperty.fromMap({
          WidgetState.pressed: AppColors.p4,
          WidgetState.hovered: AppColors.p3,
          WidgetState.disabled: Colors.grey,
          WidgetState.any: AppColors.p3,
        }),

        elevation:
            const WidgetStatePropertyAll(8.0),
      ),
    ),

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: AppColors.p3,
      foregroundColor: Colors.white,
    ),

    canvasColor: const Color(0xFF2A302C),
  );
}