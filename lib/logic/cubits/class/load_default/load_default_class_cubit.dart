import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/repositories/class_repository.dart';
import 'package:librino/logic/cubits/class/load_default/load_default_class_state.dart';

class LoadDefaultClassCubit extends Cubit<LoadDefaultClassState> {
  final ClassRepository _classRepository = Bindings.get();

  LoadDefaultClassCubit() : super(InitialLoadDefaultClassState());

  Future<void> load() async {
    try {
      emit(LoadingDefaultClassState());
      final defaultClass = await _classRepository.getDefault();
      emit(DefaultClassLoadedState(defaultClass));
    } catch (e) {
      print(e);
      emit(ErrorAtLoadDefaultClassState('Erro ao carregar a turma padrão do Librino'));
    }
  }
}
