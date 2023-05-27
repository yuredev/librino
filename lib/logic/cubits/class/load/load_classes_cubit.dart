import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/repositories/class_repository.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/class/load/load_classes_state.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';

class LoadClassesCubit extends Cubit<LoadClassesState> {
  final AuthCubit _authCubit = Bindings.get();
  final ClassRepository _classRepository = Bindings.get();
  final SelectClassCubit _selectClassCubit = Bindings.get();

  LoadClassesCubit() : super(InitialLoadClassesState()) {
    _selectClassCubit.stream.listen((_) => load());
  }

  Future<void> load() async {
    try {
      emit(LoadingClassesState());
      // TODO: se não for instrutor busca no outro serviço
      final classesFetched =
          await _classRepository.getFromInstructor(_authCubit.signedUser!.id);
      final defaultClass = await _classRepository.getDefault();
      final classes = classesFetched
          .map((c) => c.copyWith(ownerName: _authCubit.signedUser!.name))
          .toList();
      classes.insert(0, defaultClass);
      classes.removeWhere((c) => c.id == _selectClassCubit.state.clazz?.id);
      emit(ClassesLoadedState(classes));
    } catch (e) {
      print(e);
      emit(ErrorAtLoadClassesState('Erro ao carregar as turmas'));
    }
  }
}
