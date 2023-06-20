import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/data/repositories/class_repository.dart';
import 'package:librino/data/repositories/subscription_repository.dart';
import 'package:librino/data/repositories/user/firestore_user_repository.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/class/load/load_classes_state.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';

class LoadClassesCubit extends Cubit<LoadClassesState> {
  final AuthCubit _authCubit = Bindings.get();
  final ClassRepository _classRepository = Bindings.get();
  final SubscriptionRepository _subscriptionRepository = Bindings.get();
  final FirestoreUserRepository _firestoreUserRepository = Bindings.get();
  final SelectClassCubit _selectClassCubit = Bindings.get();

  LoadClassesCubit() : super(InitialLoadClassesState()) {
    _selectClassCubit.stream.listen((_) => load());
  }

  Future<void> load() async {
    try {
      emit(LoadingClassesState());
      late final List<Class> classesFetched;

      if (_authCubit.signedUser!.isInstructor) {
        classesFetched = await (_classRepository
            .getFromInstructor(_authCubit.signedUser!.id));
      } else {
        final classes = <Class>[];
        final subsFetched = await _subscriptionRepository.getBySubscriberId(
          _authCubit.signedUser!.id,
        );
        final studantSubs = subsFetched
            .where((e) => e.subscriptionStage == SubscriptionStage.approved);
        for (final sub in studantSubs) {
          final clazz = await _classRepository.getById(sub.classId);
          final owner =
              await _firestoreUserRepository.getById(clazz!.ownerId!);
          classes.add(clazz.copyWith(ownerName: owner.completeName));
        }
        classesFetched = classes;
      }
      final classes = classesFetched
          .map((c) => c.copyWith(
                ownerName: _authCubit.signedUser!.isInstructor
                    ? _authCubit.signedUser!.completeName
                    : null,
              ))
          .toList();
      classes.sort((a, b) => a.name.compareTo(b.name));
      if (!_authCubit.signedUser!.isInstructor) {
        final defaultClass = await _classRepository.getDefault();
        classes.insert(0, defaultClass);
      }
      classes.removeWhere((c) => c.id == _selectClassCubit.state.clazz?.id);
      emit(ClassesLoadedState(classes));
    } catch (e) {
      print(e);
      emit(ErrorAtLoadClassesState('Erro ao carregar as turmas'));
    }
  }
}
