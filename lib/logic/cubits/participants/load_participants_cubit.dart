import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/data/repositories/subscription_repository.dart';
import 'package:librino/data/repositories/user/firestore_user_repository.dart';
import 'package:librino/logic/cubits/participants/load_participants_state.dart';

class LoadParticipantsCubit extends Cubit<LoadParticipantsState> {
  final SubscriptionRepository _subscriptionRepository = Bindings.get();
  final FirestoreUserRepository _firestoreUserRepository = Bindings.get();

  LoadParticipantsCubit() : super(InitialLoadParticipantsState());

  Future<void> loadFromClass(String classId) async {
    try {
      emit(LoadingParticipantsState());
      final classSubscriptions =
          await _subscriptionRepository.getActivesFromClass(classId);
      
      final participants = <LibrinoUser>[];
      for (final subscription in classSubscriptions) {
        final subscriber =
            await _firestoreUserRepository.getById(subscription.subscriberId);
        final participant = LibrinoUser(
          auditoryAbility: subscriber.auditoryAbility,
          completedLessonsIds: subscriber.completedLessonsIds ?? [],
          profileType: ProfileType.studant,
          name: subscriber.name,
          surname: subscriber.surname,
          id: subscriber.id,
          email: subscriber.email ?? '',
          genderIdentity: subscriber.genderIdentity,
          photoURL: subscriber.photoUrl,
        );
        participants.add(participant);
      }
      emit(ParticipantsLoadedState(participants));
    } catch (e) {
      print(e);
      emit(LoadParticipantsErrorState(
        'Erro de conexão ao buscar os participantes',
      ));
    }
  }
}
