import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/data/models/play_lesson_dto.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/lesson/load_lesson_cubit.dart';
import 'package:librino/logic/cubits/module/load_modules_cubit.dart';
import 'package:librino/logic/cubits/participants/load_participants_cubit.dart';
import 'package:librino/logic/cubits/user/user_crud_cubit.dart';
import 'package:librino/presentation/screens/class_details_screen.dart';
import 'package:librino/presentation/screens/initial_screen/initial_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/libras_to_phrase_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/libras_to_word_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/phrase_to_libras_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/support_content_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/word_to_libras_screen.dart';
import 'package:librino/presentation/screens/introduction_screen.dart';
import 'package:librino/presentation/screens/login_screen.dart';
import 'package:librino/presentation/screens/register_screen.dart';

abstract class Routes {
  static const home = '/home';
  static const intro = '/intro';
  static const register = '/register';
  static const classDetails = '/class-details';
  static const login = '/login';
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
                BlocProvider<LoadLessonCubit>.value(value: Bindings.get()),
                BlocProvider<AuthCubit>.value(value: Bindings.get())
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
    }
    return null;
  }
}
