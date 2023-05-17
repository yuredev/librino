import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/logic/cubits/participants/load_participants_state.dart';

class LoadParticipantsCubit extends Cubit<LoadParticipantsState> {
  LoadParticipantsCubit() : super(InitialLoadParticipantsState());

  Future<void> loadFromClass(String classId) async {
    try {
      emit(LoadingParticipantsState());
      await Future.delayed(Duration(seconds: 4));
      final participants = <LibrinoUser>[
        // LibrinoUser(isDeaf: false),
        // LibrinoUser(isDeaf: false),
        // LibrinoUser(isDeaf: false),
        // LibrinoUser(isDeaf: false),
        // LibrinoUser(isDeaf: false),
        // LibrinoUser(isDeaf: false),
        // LibrinoUser(isDeaf: false),
        // LibrinoUser(isDeaf: false),
      ];
      emit(ParticipantsLoadedState(participants));
    } catch (e) {
      print(e);
      // TODO: verificar quando é erro de conexão
      // O firebase não usa DIO :|
      emit(LoadParticipantsErrorState(
        'Erro de conexão ao buscar os participantes',
      ));
    }
  }
}
