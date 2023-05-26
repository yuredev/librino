import 'package:flutter/material.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/presentation/themes.dart';
import 'package:librino/presentation/widgets/shared/global_alerts_handler.dart';

import 'core/routes.dart';

class LibrinoApp extends StatelessWidget {
  const LibrinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Bindings.get<AuthCubit>().state;
    return MaterialApp(
      theme: Themes.light,
      initialRoute: authState is LoggedInState ? Routes.home : Routes.login,
      onGenerateRoute: Routes.onGenerateRoute,
      builder: (context, child) => GlobalAlertsHandler(child: child),
    );
  }
}
