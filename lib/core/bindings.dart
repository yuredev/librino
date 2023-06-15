import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/config/environment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librino/data/repositories/auth_repository.dart';
import 'package:librino/data/repositories/class_repository.dart';
import 'package:librino/data/repositories/lesson_repository.dart';
import 'package:librino/data/repositories/module_repository.dart';
import 'package:librino/data/repositories/question_repository.dart';
import 'package:librino/data/repositories/subscription_repository.dart';
import 'package:librino/data/repositories/user/fireauth_user_repository.dart';
import 'package:librino/data/repositories/user/firestore_user_repository.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/class/actions/class_actions_cubit.dart';
import 'package:librino/logic/cubits/class/load/load_classes_cubit.dart';
import 'package:librino/logic/cubits/class/load_default/load_default_class_cubit.dart';
import 'package:librino/logic/cubits/class/search/search_class_cubit.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/lesson/actions/lesson_actions_cubit.dart';
import 'package:librino/logic/cubits/lesson/load/load_lessons_cubit.dart';
import 'package:librino/logic/cubits/lesson/load/load_single_lesson_cubit.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_cubit.dart';
import 'package:librino/logic/cubits/module/load/load_modules_cubit.dart';
import 'package:librino/logic/cubits/participants/load_participants_cubit.dart';
import 'package:librino/logic/cubits/question/actions/question_actions_cubit.dart';
import 'package:librino/logic/cubits/question/load_questions/load_lesson_questions_cubit.dart';
import 'package:librino/logic/cubits/question/load_questions/load_questions_base_cubit.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_cubit.dart';
import 'package:librino/logic/cubits/subscription/load/load_subscriptions_cubit.dart';
import 'package:librino/logic/cubits/user/user_crud_cubit.dart';

abstract class Bindings {
  static T get<T extends Object>({String? instanceName}) {
    return GetIt.I.get<T>(instanceName: instanceName);
  }

  static void set<T extends Object>(T object, {String? instanceName}) {
    GetIt.I.registerLazySingleton<T>(() => object, instanceName: instanceName);
  }

  static Future<void> init(EnvironmentSettings settings) async {
    set(ImagePicker());
    set(FirebaseFirestore.instance);
    set(FirebaseStorage.instance.ref());
    set(FirestoreUserRepository());
    set(FireAuthUserRepository());
    set(ClassRepository());
    set(QuestionRepository());
    set(AuthRepository());
    set(SubscriptionRepository());
    set(ModuleRepository());
    set(LessonRepository());
    set(GlobalAlertCubit());
    set(SelectClassCubit());
    set(LoadLessonQuestionsCubit());
    set(LoadQuestionBaseCubit());
    set(LessonActionsCubit());
    set(LoadModulesCubit());
    set(ModuleActionsCubit());
    set(AuthCubit());
    set(UserCRUDCubit());
    set(LoadSingleLessonCubit());
    set(LoadLessonsCubit());
    set(SearchClassCubit());
    set(LoadSubscriptionsCubit());
    set(SubscriptionActionsCubit());
    set(LoadClassesCubit());
    set(LoadDefaultClassCubit());
    set(LoadParticipantsCubit());
    set(ClassActionsCubit());
    set(QuestionActionsCubit());
  }
}
