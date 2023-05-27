import 'package:get_it/get_it.dart';
import 'package:librino/core/config/environment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librino/data/repositories/auth_repository.dart';
import 'package:librino/data/repositories/class_repository.dart';
import 'package:librino/data/repositories/lesson_repository.dart';
import 'package:librino/data/repositories/module_repository.dart';
import 'package:librino/data/repositories/user/fireauth_user_repository.dart';
import 'package:librino/data/repositories/user/firestore_user_repository.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/class/crud/class_crud_cubit.dart';
import 'package:librino/logic/cubits/class/load/load_classes_cubit.dart';
import 'package:librino/logic/cubits/class/load_default/load_default_class_cubit.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/lesson/load_lesson_cubit.dart';
import 'package:librino/logic/cubits/module/load_modules_cubit.dart';
import 'package:librino/logic/cubits/participants/load_participants_cubit.dart';
import 'package:librino/logic/cubits/user/user_crud_cubit.dart';

abstract class Bindings {
  static T get<T extends Object>({String? instanceName}) {
    return GetIt.I.get<T>(instanceName: instanceName);
  }

  static void set<T extends Object>(T object, {String? instanceName}) {
    GetIt.I.registerLazySingleton<T>(() => object, instanceName: instanceName);
  }

  static Future<void> init(EnvironmentSettings settings) async {
    set(FirebaseFirestore.instance);
    set(FirestoreUserRepository());
    set(FireAuthUserRepository());
    set(ClassRepository());
    set(AuthRepository());
    set(GlobalAlertCubit());
    set(AuthCubit());
    set(UserCRUDCubit());
    set(ModuleRepository());
    set(LessonRepository());
    set(LoadLessonCubit());
    set(LoadModulesCubit());
    set(SelectClassCubit());
    set(LoadClassesCubit());
    set(LoadDefaultClassCubit());
    set(LoadParticipantsCubit());
    set(ClassCRUDCubit());
  }
}
