import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/data/repositories/class_repository.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/class/crud/class_crud_state.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:uuid/uuid.dart';

class ClassCRUDCubit extends Cubit<ClassCRUDState> {
  final ClassRepository _classRepository = Bindings.get();
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();
  final AuthCubit _authCubit = Bindings.get();
  final _uuid = Uuid();

  ClassCRUDCubit() : super(InitialClassCRUDState());

  Future<void> create(Class clazz) async {
    try {
      emit(CreatingClassState());
      final owner = (_authCubit.state as LoggedInState).user;
      final classToCreate = clazz.copyWith(
        id: _uuid.v4(),
        ownerId: owner.id,
      );
      final createdClass = await _classRepository.create(classToCreate);
      emit(ClassCreatedState(createdClass));
    } catch (e) {
      print(e);
      _globalAlertCubit.fire('Erro ao cadastrar turma', isErrorMessage: true);
      emit(ErrorCreatingClassState('Erro ao cadastrar turma'));
    }
  }
}
