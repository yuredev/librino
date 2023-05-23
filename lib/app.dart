import 'package:flutter/material.dart';
import 'package:librino/presentation/themes.dart';
import 'package:librino/presentation/widgets/shared/global_alerts_handler.dart';

import 'core/routes.dart';

class LibrinoApp extends StatelessWidget {
  const LibrinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.light,
      initialRoute: Routes.login,
      onGenerateRoute: Routes.onGenerateRoute,
      builder: (context, child) => GlobalAlertsHandler(child: child),
    );
  }
}
