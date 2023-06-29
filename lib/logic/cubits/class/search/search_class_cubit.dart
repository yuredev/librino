import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/repositories/class_repository.dart';
import 'package:librino/data/repositories/subscription_repository.dart';
import 'package:librino/data/repositories/user/firestore_user_repository.dart';
import 'package:librino/logic/cubits/class/search/search_class_state.dart';

class SearchClassCubit extends Cubit<SearchClassState> {
  final ClassRepository _classRepository = Bindings.get();
  final FirestoreUserRepository _userRepository = Bindings.get();
  final SubscriptionRepository _subscriptionRepository = Bindings.get();

  SearchClassCubit() : super(InitialSearchClassState());

  void reset() => emit(InitialSearchClassState());

  Future<void> search(String id) async {
    try {
      emit(SearchingClassState());
      await Future.delayed(Duration(milliseconds: 500));
      final clazz = await _classRepository.getById(id);
      if (clazz == null) {
        emit(ClassNotFoundState());
        return;
      }
      final participantesCount =
          await _subscriptionRepository.getParticipantsCount(id);
      final owner = await _userRepository.getById(clazz.ownerId!);
      // TODO: colocar o name também no FirestoreUser
      emit(ClassFoundState(clazz.copyWith(
        ownerName: owner.completeName,
        name: clazz.name,
        participantsCount: participantesCount,
      )));
    } catch (e) {
      print(e);
      emit(SearchClassErrorState('Erro ao buscar a turma'));
    }
  }
}
