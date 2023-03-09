import 'package:get_it/get_it.dart';
import 'package:librino/core/config/environment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librino/data/repositories/lesson_repository.dart';
import 'package:librino/data/repositories/module_repository.dart';
import 'package:librino/logic/cubits/lesson/load_lesson_cubit.dart';
import 'package:librino/logic/cubits/module/load_modules_cubit.dart';

abstract class Bindings {
  static Future<void> init(EnvironmentSettings settings) async {
    GetIt.I.registerLazySingleton(() => FirebaseFirestore.instance);
    GetIt.I.registerLazySingleton(() => ModuleRepository());
    GetIt.I.registerLazySingleton(() => LessonRepository());
    GetIt.I.registerLazySingleton(() => LoadLessonCubit());
    GetIt.I.registerLazySingleton(() => LoadModulesCubit());
  }
}
