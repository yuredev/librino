import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/subscription/subscription.dart';
import 'package:librino/data/repositories/class_repository.dart';
import 'package:librino/data/repositories/subscription_repository.dart';
import 'package:librino/data/repositories/user/firestore_user_repository.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/subscription/load/load_subscriptions_state.dart';

class LoadSubscriptionsCubit extends Cubit<LoadSubscriptionsState> {
  final SubscriptionRepository _subscriptionRepository = Bindings.get();
  final FirestoreUserRepository _firestoreUserRepository = Bindings.get();
  final ClassRepository _classRepository = Bindings.get();
  final AuthCubit _authCubit = Bindings.get();

  LoadSubscriptionsCubit() : super(InitialLoadSubscriptionsState());

  Future<void> load() async {
    try {
      emit(LoadingSubcriptionsState());
      final user = _authCubit.signedUser!;
      final instructorSubs = <Subscription>[];

      if (user.isInstructor) {
        final instructorClasses =
            await _classRepository.getFromInstructor(user.id);
        for (final clazz in instructorClasses) {
          final classSubs =
              await _subscriptionRepository.getFromClass(clazz.id);
          instructorSubs.addAll(classSubs);
        }
      }
      final subs = user.isInstructor
          ? instructorSubs
          : await _subscriptionRepository.getBySubscriberId(user.id);
      subs.sort((s1, s2) => s1.requestDate.compareTo(s2.requestDate));
      final finalSubs = <Subscription>[];
      for (final sub in subs) {
        final clazz = await _classRepository.getById(sub.classId);
        if (user.isInstructor) {
          final subscriber =
              await _firestoreUserRepository.getById(sub.subscriberId);
          finalSubs.add(sub.copyWith(
            className: clazz!.name,
            subscriberName: subscriber.completeName,
            responsibleId: user.id,
            responsibleName: user.name,
          ));
        } else {
          final responsible =
              await _firestoreUserRepository.getById(clazz!.ownerId!);
          finalSubs.add(sub.copyWith(
            className: clazz.name,
            subscriberName: user.completeName,
            responsibleId: responsible.id,
            responsibleName: responsible.completeName,
          ));
        }
      }
      emit(SubscriptionsLoadedState(finalSubs));
    } catch (e) {
      print(e);
      emit(LoadSubscriptionsErrorState(
        'Erro ao carregar suas solicitações de matrículas',
      ));
    }
  }
}
