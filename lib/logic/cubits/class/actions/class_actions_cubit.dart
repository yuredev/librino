import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/data/repositories/class_repository.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/class/actions/class_actions_state.dart';
import 'package:librino/logic/cubits/class/load/load_classes_cubit.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';

class ClassActionsCubit extends Cubit<ClassActionsState> {
  final ClassRepository _classRepository = Bindings.get();
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();
  final LoadClassesCubit _loadClassesCubit = Bindings.get();
  final AuthCubit _authCubit = Bindings.get();

  ClassActionsCubit() : super(InitialClassActionsState());

  Future<void> create(Class clazz) async {
    try {
      emit(CreatingClassState());
      final classToCreate = clazz.copyWith(
        ownerId: _authCubit.signedUser!.id,
      );
      final createdClass = await _classRepository.create(classToCreate);
      emit(ClassCreatedState(createdClass));
      _loadClassesCubit.load();
    } catch (e) {
      print(e);
      _globalAlertCubit.fire('Erro ao cadastrar turma', isErrorMessage: true);
      emit(ErrorCreatingClassState('Erro ao cadastrar turma'));
    }
  }
}
