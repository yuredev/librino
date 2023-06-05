import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/data/models/play_lesson_dto.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/class/actions/class_actions_cubit.dart';
import 'package:librino/logic/cubits/class/load/load_classes_cubit.dart';
import 'package:librino/logic/cubits/class/load_default/load_default_class_cubit.dart';
import 'package:librino/logic/cubits/class/search/search_class_cubit.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/logic/cubits/lesson/actions/lesson_actions_cubit.dart';
import 'package:librino/logic/cubits/lesson/load/load_lessons_cubit.dart';
import 'package:librino/logic/cubits/lesson/load/load_single_lesson_cubit.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_cubit.dart';
import 'package:librino/logic/cubits/module/load/load_modules_cubit.dart';
import 'package:librino/logic/cubits/participants/load_participants_cubit.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_cubit.dart';
import 'package:librino/logic/cubits/subscription/load/load_subscriptions_cubit.dart';
import 'package:librino/logic/cubits/user/user_crud_cubit.dart';
import 'package:librino/presentation/screens/class_details_screen.dart';
import 'package:librino/presentation/screens/create_class_screen.dart';
import 'package:librino/presentation/screens/add_lessons_to_module_screen.dart';
import 'package:librino/presentation/screens/create_module_screen.dart';
import 'package:librino/presentation/screens/initial_screen/initial_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/libras_to_phrase_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/libras_to_word_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/phrase_to_libras_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/support_content_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/word_to_libras_screen.dart';
import 'package:librino/presentation/screens/introduction_screen.dart';
import 'package:librino/presentation/screens/login_screen.dart';
import 'package:librino/presentation/screens/register_screen.dart';
import 'package:librino/presentation/screens/search_class_screen.dart';

abstract class Routes {
  static const home = '/home';
  static const intro = '/intro';
  static const register = '/register';
  static const classDetails = '/class-details';
  static const login = '/login';
  static const createClass = '/create-class';
  static const searchClass = '/search-class';
  static const createModule = '/create-module';
  static const addLessonsToModule = '/create-lesson';
  // Lesson
  static const supportContent = '/support-content';
  static const librasToPhraseQuestion = '/libras-to-phrase-question';
  static const phraseToLibrasQuestion = '/phrase-to-libras-question';
  static const wordToLibrasQuestion = '/word-to-libras-question';
  static const librasToWordQuestion = '/libras-to-word-question';

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case intro:
        return MaterialPageRoute(builder: (ctx) {
          return BlocProvider<AuthCubit>.value(
            value: Bindings.get(),
            child: IntroductionScreen(),
          );
        });
      case login:
        return MaterialPageRoute(builder: (ctx) {
          return BlocProvider<AuthCubit>.value(
            value: Bindings.get(),
            child: LoginScreen(),
          );
        });
      case register:
        return MaterialPageRoute(builder: (ctx) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthCubit>.value(value: Bindings.get()),
              BlocProvider<UserCRUDCubit>.value(value: Bindings.get())
            ],
            child: RegisterScreen(),
          );
        });
      case home:
        return MaterialPageRoute(
          builder: (ctx) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<LoadModulesCubit>.value(value: Bindings.get()),
                BlocProvider<LoadSingleLessonCubit>.value(value: Bindings.get()),
                BlocProvider<LoadClassesCubit>.value(value: Bindings.get()),
                BlocProvider<AuthCubit>.value(value: Bindings.get()),
                BlocProvider<SelectClassCubit>.value(value: Bindings.get()),
                BlocProvider<SubscriptionActionsCubit>.value(
                    value: Bindings.get()),
                BlocProvider<LoadDefaultClassCubit>.value(
                  value: Bindings.get(),
                ),
                BlocProvider<LoadSubscriptionsCubit>.value(
                  value: Bindings.get(),
                ),
              ],
              child: InitialScreen(),
            );
          },
        );
      case phraseToLibrasQuestion:
        final playDTO = settings.arguments as PlayLessonDTO;
        return MaterialPageRoute(
          builder: (ctx) {
            return PhraseToLibrasScreen(playLessonDTO: playDTO);
          },
        );
      case wordToLibrasQuestion:
        final playDTO = settings.arguments as PlayLessonDTO;
        return MaterialPageRoute(
          builder: (ctx) => WordToLibrasScreen(playLessonDTO: playDTO),
        );
      case librasToWordQuestion:
        final playDTO = settings.arguments as PlayLessonDTO;
        return MaterialPageRoute(
          builder: (ctx) => LibrasToWordScreen(playLessonDTO: playDTO),
        );
      case librasToPhraseQuestion:
        final playDTO = settings.arguments as PlayLessonDTO;
        return MaterialPageRoute(
          builder: (ctx) => LibrasToPhraseScreen(playLessonDTO: playDTO),
        );
      case supportContent:
        final playDTO = settings.arguments as PlayLessonDTO;
        return MaterialPageRoute(
          builder: (ctx) => SupportContentScreen(
            playLessonDTO: playDTO,
          ),
        );
      case classDetails:
        return MaterialPageRoute(
          builder: (ctx) {
            return BlocProvider<LoadParticipantsCubit>.value(
              value: Bindings.get(),
              child: ClassDetailsScreen(
                clazz: (settings.arguments as Map)['class'] as Class,
              ),
            );
          },
        );
      case createClass:
        return MaterialPageRoute(
          builder: (ctx) => BlocProvider<ClassActionsCubit>.value(
            value: Bindings.get(),
            child: CreateClassScreen(),
          ),
        );
      case searchClass:
        return MaterialPageRoute(
          builder: (ctx) => MultiBlocProvider(
            providers: [
              BlocProvider<SubscriptionActionsCubit>.value(
                value: Bindings.get(),
              ),
              BlocProvider<SearchClassCubit>.value(value: Bindings.get()),
            ],
            child: SearchClassScreen(),
          ),
        );
      case createModule:
        return MaterialPageRoute(
          builder: (ctx) => BlocProvider<ModuleActionsCubit>.value(
            value: Bindings.get(),
            child: CreateModuleScreen(
              clazz: (settings.arguments as Map)['class'],
            ),
          ),
        );
      case addLessonsToModule:
        return MaterialPageRoute(
          builder: (ctx) => BlocProvider<LoadLessonsCubit>.value(
            value: Bindings.get(),
            child: AddLessonsToModuleScreen(),
          ),
        );
    }
    return null;
  }
}
