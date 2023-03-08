import 'package:flutter/material.dart';
import 'package:librino/app.dart';
import 'package:librino/core/config/environment.dart';
import 'package:flutter/services.dart';
import 'package:librino/core/bindings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  const settings = EnvironmentSettings();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Bindings.init(settings);

  runApp(
    Environment(
      settings,
      child: LibrinoApp(),
    ),
  );
}
