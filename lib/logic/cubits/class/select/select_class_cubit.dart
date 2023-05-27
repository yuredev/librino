import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/constants/storage_keys.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/logic/cubits/class/select/select_class_state.dart';
import 'package:librino/logic/cubits/module/load_modules_cubit.dart';

class SelectClassCubit extends HydratedCubit<SelectClassState> {
  final LoadModulesCubit _loadModulesCubit = Bindings.get();

  SelectClassCubit() : super(SelectClassState(null));

  void select(Class clazz) {
    emit(SelectClassState(clazz));
    _loadModulesCubit.loadFromClass(clazz.id!);
  }

  @override
  SelectClassState? fromJson(Map<String, dynamic> json) =>
      SelectClassState(Class.fromJson(json[StorageKeys.selectedClass]));

  @override
  Map<String, dynamic>? toJson(SelectClassState state) => {
        StorageKeys.selectedClass: state.clazz?.toJson(),
      };
}
