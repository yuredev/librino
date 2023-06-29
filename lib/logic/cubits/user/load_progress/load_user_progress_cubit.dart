import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/subscription/subscription.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/data/models/user_progress/user_progress.dart';
import 'package:librino/data/repositories/class_repository.dart';
import 'package:librino/data/repositories/lesson_repository.dart';
import 'package:librino/data/repositories/module_repository.dart';
import 'package:librino/data/repositories/subscription_repository.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/user/load_progress/load_user_progress_state.dart';

class LoadUserProgressCubit extends Cubit<LoadUserProgressState> {
  final ModuleRepository _moduleRepository = Bindings.get();
  final LessonRepository _lessonRepository = Bindings.get();
  final ClassRepository _classRepository = Bindings.get();
  final SubscriptionRepository _subscriptionRepository = Bindings.get();
  final AuthCubit _authCubit = Bindings.get();

  LoadUserProgressCubit() : super(InitialUserProgressState());

  Future<void> load(LibrinoUser user) async {
    try {
      assert(_authCubit.signedUser!.isInstructor);
      emit(LoadingUserProgressState());
      final progressArray = <UserProgress>[];
      final userSubscriptions = <Subscription>[];
      final myClasses =
          await _classRepository.getFromInstructor(_authCubit.signedUser!.id);
      for (final clazz in myClasses) {
        final sub = await _subscriptionRepository.getBySubscriberAndClass(
          user.id,
          clazz.id!,
        );
        if (sub != null) userSubscriptions.add(sub);
      }
      for (final sub in userSubscriptions) {
        final modules = await _moduleRepository.getFromClass(sub.classId);
        for (final m in modules) {
          final moduleLessons = await _lessonRepository.getFromModule(m.id!);
          final moduleWithLessons = m.copyWith(lessons: moduleLessons);
          progressArray.add(
            UserProgress(
              moduleWithLessons,
              user.completedLessonsIds
                  .where((lessonId) =>
                      moduleLessons.map((e) => e.id).contains(lessonId))
                  .length,
            ),
          );
        }
      }
      emit(UserProgressLoadedState(progressArray));
    } catch (e) {
      print(e);
      emit(LoadUserProgressErrorState(
          'Erro ao carregar o progresso do usuário nos módulos'));
    }
  }
}
