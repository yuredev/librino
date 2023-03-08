import 'package:flutter/material.dart';

class EnvironmentSettings {
  const EnvironmentSettings();
}

class Environment extends InheritedWidget {
  final EnvironmentSettings settings;

  const Environment(
    this.settings, {
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
