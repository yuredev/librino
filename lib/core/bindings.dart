import 'package:get_it/get_it.dart';
import 'package:librino/core/config/environment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librino/data/repository/module_repository.dart';
import 'package:librino/logic/cubits/module/home_modules_list/home_modules_list_cubit.dart';

abstract class Bindings {
  static Future<void> init(EnvironmentSettings settings) async {
    GetIt.I.registerLazySingleton(() => FirebaseFirestore.instance);
    GetIt.I.registerLazySingleton(() => ModuleRepository());
    GetIt.I.registerLazySingleton(() => HomeModulesListCubit());
  }
}
