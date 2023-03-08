import 'package:flutter/material.dart';
import 'package:librino/presentation/themes.dart';

import 'core/routes.dart';

class LibrinoApp extends StatelessWidget {
  const LibrinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.light,
      initialRoute: Routes.home,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}