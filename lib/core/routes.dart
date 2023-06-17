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
import 'package:librino/logic/cubits/question/actions/question_actions_cubit.dart';
import 'package:librino/logic/cubits/question/load_questions/load_lesson_questions_cubit.dart';
import 'package:librino/logic/cubits/question/load_questions/load_questions_base_cubit.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_cubit.dart';
import 'package:librino/logic/cubits/subscription/load/load_subscriptions_cubit.dart';
import 'package:librino/logic/cubits/user/user_crud_cubit.dart';
import 'package:librino/presentation/screens/class_details_screen.dart';
import 'package:librino/presentation/screens/content_creation/add_lessons_to_module_screen.dart';
import 'package:librino/presentation/screens/content_creation/add_question_to_lesson_screen.dart';
import 'package:librino/presentation/screens/content_creation/create_lesson_screen.dart';
import 'package:librino/presentation/screens/content_creation/create_module_screen.dart';
import 'package:librino/presentation/screens/content_creation/create_questions/create_libras_to_phrase_screen.dart';
import 'package:librino/presentation/screens/content_creation/create_questions/create_libras_to_word_screen.dart';
import 'package:librino/presentation/screens/content_creation/create_questions/create_phrase_to_libras_screen.dart';
import 'package:librino/presentation/screens/content_creation/create_questions/create_word_to_libras_screen.dart';
import 'package:librino/presentation/screens/create_class_screen.dart';
import 'package:librino/presentation/screens/home/home.dart';
import 'package:librino/presentation/screens/lesson_result_screen.dart';
import 'package:librino/presentation/screens/play_questions/libras_to_phrase_screen.dart';
import 'package:librino/presentation/screens/play_questions/libras_to_word_screen.dart';
import 'package:librino/presentation/screens/play_questions/phrase_to_libras_screen.dart';
import 'package:librino/presentation/screens/play_questions/word_to_libras_screen.dart';
import 'package:librino/presentation/screens/introduction_screen.dart';
import 'package:librino/presentation/screens/login_screen.dart';
import 'package:librino/presentation/screens/preview_question_screen.dart';
import 'package:librino/presentation/screens/register_screen.dart';
import 'package:librino/presentation/screens/reorder_modules_screen.dart';
import 'package:librino/presentation/screens/search_class_screen.dart';
import 'package:librino/presentation/screens/select_question_type_screen.dart';
import 'package:librino/presentation/screens/support_content_screen.dart';

abstract class Routes {
  static const home = '/home';
  static const intro = '/intro';
  static const register = '/register';
  static const classDetails = '/class-details';
  static const login = '/login';
  static const createClass = '/create-class';
  static const searchClass = '/search-class';
  static const createModule = '/create-module';
  static const addLessonsToModule = '/add-lessons-to-module';
  static const createLesson = '/create-lesson';
  static const addQuestionToLesson = '/add-questions-to-lesson';
  static const selectQuestionType = '/select-question-type';
  static const viewSupportContent = '/view-support-content';
  static const previewQuestion = '/preview-question';
  static const camera = '/camera';
  static const reorderModules = '/reorder-modules';

  // Create questions
  static const createLIBRASToPhraseQuestion =
      'create-LIBRAS-to-phrase-question';
  static const createLIBRASToWordQuestion = 'create-LIBRAS-to-word-question';
  static const createWordToLIBRASQuestion = 'create-word-to-LIBRAS-question';
  static const createPhraseToLIBRASQuestion =
      'create-phrase-to-LIBRAS-question';
  // Play questions
  static const librasToPhraseQuestion = '/libras-to-phrase-question';
  static const phraseToLibrasQuestion = '/phrase-to-libras-question';
  static const wordToLibrasQuestion = '/word-to-libras-question';
  static const librasToWordQuestion = '/libras-to-word-question';
  static const lessonResult = '/lesson-result';

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (ctx) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<LoadModulesCubit>.value(value: Bindings.get()),
                BlocProvider<LoadSingleLessonCubit>.value(
                  value: Bindings.get(),
                ),
                BlocProvider<LoadClassesCubit>.value(value: Bindings.get()),
                BlocProvider<AuthCubit>.value(value: Bindings.get()),
                BlocProvider<SelectClassCubit>.value(value: Bindings.get()),
                BlocProvider<SubscriptionActionsCubit>.value(
                  value: Bindings.get(),
                ),
                BlocProvider<LoadDefaultClassCubit>.value(
                  value: Bindings.get(),
                ),
                BlocProvider<LoadSubscriptionsCubit>.value(
                  value: Bindings.get(),
                ),
                BlocProvider<LoadLessonQuestionsCubit>.value(
                  value: Bindings.get(),
                ),
              ],
              child: Home(),
            );
          },
        );
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
      case viewSupportContent:
        final playDTO = settings.arguments as PlayLessonDTO;
        return MaterialPageRoute(
          builder: (ctx) => SupportContentScreen(playLessonDTO: playDTO),
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
          builder: (ctx) => MultiBlocProvider(
            providers: [
              BlocProvider<LoadLessonsCubit>.value(
                value: Bindings.get(),
              ),
              BlocProvider<LessonActionsCubit>.value(
                value: Bindings.get(),
              ),
            ],
            child: AddLessonsToModuleScreen(
              module: (settings.arguments as Map)['module'],
            ),
          ),
        );
      case createLesson:
        return MaterialPageRoute(
          builder: (ctx) => BlocProvider<LessonActionsCubit>.value(
            value: Bindings.get(),
            child: CreateLessonScreen(
              module: (settings.arguments as Map)['module'],
              lessonCreationIndex:
                  (settings.arguments as Map)['lessonCreationIndex'],
            ),
          ),
        );
      case addQuestionToLesson:
        return MaterialPageRoute(
          builder: (ctx) => MultiBlocProvider(
            providers: [
              BlocProvider<LoadQuestionBaseCubit>.value(
                value: Bindings.get(),
              ),
              BlocProvider<QuestionActionsCubit>.value(
                value: Bindings.get(),
              ),
            ],
            child: AddQuestionToLessonScreen(),
          ),
        );
      case selectQuestionType:
        return MaterialPageRoute(builder: (ctx) => SelectQuestionTypeScreen());
      case createLIBRASToPhraseQuestion:
        return MaterialPageRoute(
          builder: (ctx) => BlocProvider<QuestionActionsCubit>.value(
            value: Bindings.get(),
            child: CreateLIBRASToPhraseScreen(),
          ),
        );
      case createPhraseToLIBRASQuestion:
        return MaterialPageRoute(
          builder: (ctx) => BlocProvider<QuestionActionsCubit>.value(
            value: Bindings.get(),
            child: CreatePhraseToLIBRASScreen(),
          ),
        );
      case createLIBRASToWordQuestion:
        return MaterialPageRoute(
          builder: (ctx) => BlocProvider<QuestionActionsCubit>.value(
            value: Bindings.get(),
            child: CreateLIBRASToWordScreen(),
          ),
        );
      case createWordToLIBRASQuestion:
        return MaterialPageRoute(
          builder: (ctx) => BlocProvider<QuestionActionsCubit>.value(
            value: Bindings.get(),
            child: CreateWordToLIBRASScreen(),
          ),
        );
      case previewQuestion:
        return MaterialPageRoute(
          builder: (ctx) => PreviewQuestionScreen(
            question: (settings.arguments as Map)['question'],
            readOnly: (settings.arguments as Map)['readOnly'] ?? false,
          ),
        );
      // case camera:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return CameraScreenOld(
      //         isVideo: (settings.arguments as Map)['isVideo'] ?? false,
      //         startInFrontal: (settings.arguments as Map)['startInFrontal'],
      //       );
      //     },
      //   );
      case lessonResult:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<LessonActionsCubit>.value(
            value: Bindings.get(),
            child: LessonResultScreen(
              hasFailed: (settings.arguments as Map)['hasFailed'],
              lessonId: (settings.arguments as Map)['lessonId'],
            ),
          ),
        );
      case reorderModules:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<ModuleActionsCubit>.value(
                value: Bindings.get(),
              ),
              BlocProvider<LoadModulesCubit>.value(
                value: Bindings.get(),
              ),
              BlocProvider<AuthCubit>.value(
                value: Bindings.get(),
              ),
            ],
            child: ReorderModulesScreen(),
          ),
        );
    }
    return null;
  }
}
