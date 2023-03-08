import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';

abstract class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: LibrinoColors.backgroundWhite,
    textTheme: TextTheme(
      titleLarge: TextStyle(color: LibrinoColors.mainOrange),
    ),
    primarySwatch: MaterialColor(
      LibrinoColors.mainOrange.value,
      {
        50: LibrinoColors.mainOrange,
        100: LibrinoColors.mainOrange,
        200: LibrinoColors.mainOrange,
        300: LibrinoColors.mainOrange,
        400: LibrinoColors.mainOrange,
        500: LibrinoColors.mainOrange,
        600: LibrinoColors.mainOrange,
        700: LibrinoColors.mainOrange,
        800: LibrinoColors.mainOrange,
        900: LibrinoColors.mainOrange,
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
