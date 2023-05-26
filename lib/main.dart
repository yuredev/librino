import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:librino/app.dart';
import 'package:librino/core/config/environment.dart';
import 'package:flutter/services.dart';
import 'package:librino/core/bindings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:librino/core/constants/directories.dart';
import 'firebase_options.dart';

void main() async {
  const settings = EnvironmentSettings();
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await Directories.getKeystoreDir(),
  );
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
