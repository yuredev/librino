import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:librino/logic/cubits/lesson/load_lesson_cubit.dart';
import 'package:librino/logic/cubits/module/load_modules_cubit.dart';
import 'package:librino/presentation/screens/home_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/libras_to_phrase_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/libras_to_word_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/phrase_to_libras_screen.dart';
import 'package:librino/presentation/screens/lesson_steps/word_to_libras_screen.dart';
import 'package:librino/presentation/widgets/home/lesson_modal_widget.dart';

abstract class Routes {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  // questions
  static const librasToPhraseQuestion = '/libras-to-phrase-question';
  static const phraseToLibrasQuestion = '/phrase-to-libras-question';
  static const wordToLibrasQuestion = '/word-to-libras-question';
  static const librasToWordQuestion = '/libras-to-word-question';

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (ctx) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<LoadModulesCubit>.value(value: GetIt.I.get()),
                BlocProvider<LoadLessonCubit>.value(value: GetIt.I.get())
              ],
              child: HomeScreenWidget(),
            );
          },
        );
      case phraseToLibrasQuestion:
        return MaterialPageRoute(
          builder: (ctx) {
            return PhraseToLibrasScreen();
          },
        );
      case wordToLibrasQuestion:
        return MaterialPageRoute(
          builder: (ctx) => WordToLibrasScreen(),
        );
      case librasToWordQuestion:
        return MaterialPageRoute(
          builder: (ctx) => LibrasToWordScreen(),
        );
      case librasToPhraseQuestion:
        return MaterialPageRoute(
          builder: (ctx) => LibrasToPhraseScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (ctx) {
            return SizedBox();
          },
        );
    }
  }
}
