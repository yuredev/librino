import 'package:flutter/material.dart';

class LoadingBarAppBarWidget extends LinearProgressIndicator
    implements PreferredSizeWidget {
  LoadingBarAppBarWidget({
    Key? key,
    double? value,
    Color? backgroundColor,
    Animation<Color>? valueColor,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
        );

  @override
  final Size preferredSize = Size(double.infinity, 3.0);
}
