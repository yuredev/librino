import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';

abstract class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: LibrinoColors.backgroundWhite,
    textTheme: TextTheme(
      titleLarge: TextStyle(color: LibrinoColors.main),
    ),
    primarySwatch: MaterialColor(
      LibrinoColors.main.value,
      {
        50: LibrinoColors.main,
        100: LibrinoColors.main,
        200: LibrinoColors.main,
        300: LibrinoColors.main,
        400: LibrinoColors.main,
        500: LibrinoColors.main,
        600: LibrinoColors.main,
        700: LibrinoColors.main,
        800: LibrinoColors.main,
        900: LibrinoColors.main,
      },
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusColor: LibrinoColors.lightGray,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        )
      )
    ),
  );
}
