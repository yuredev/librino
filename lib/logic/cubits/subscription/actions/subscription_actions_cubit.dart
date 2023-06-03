import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/core/errors/firebase_custom_error.dart';
import 'package:librino/data/models/subscription/subscription.dart';
import 'package:librino/data/repositories/subscription_repository.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_state.dart';
import 'package:librino/logic/cubits/subscription/load/load_subscriptions_cubit.dart';

import '../../../../core/bindings.dart';

class SubscriptionActionsCubit extends Cubit<SubscriptionActionsState> {
  final AuthCubit _authCubit = Bindings.get();
  final SubscriptionRepository _subsRepository = Bindings.get();
  final LoadSubscriptionsCubit _loadSubscriptionsCubit = Bindings.get();
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();

  SubscriptionActionsCubit() : super(InitialSubscriptionActionsState());

  Future<void> approve(String subscriptionId) async {
    try {
      emit(ApprovingSubscriptionState());
      await _subsRepository.approve(subscriptionId);
      _loadSubscriptionsCubit.load();
      _globalAlertCubit.fire('Matricula aprovada!');
      emit(SubscriptionApprovedState());
    } catch (e) {
      print(e);
      _globalAlertCubit.fire(
        'Erro ao aprovar a solicitação de matrícula',
        isErrorMessage: true,
      );
      emit(ApproveSubscriptionError(
        'Erro ao aprovar a solicitação de matrícula',
      ));
    }
  }

  Future<void> repprove(String subscriptionId) async {
    try {
      emit(RepprovingSubscriptionState());
      await _subsRepository.repprove(subscriptionId);
      _loadSubscriptionsCubit.load();
      _globalAlertCubit.fire('Matricula reprovada!');
      emit(SubscriptionRepprovedState());
    } catch (e) {
      print(e);
      _globalAlertCubit.fire(
        'Erro ao reprovar a solicitação de matrícula',
        isErrorMessage: true,
      );
      emit(RepproveSubscriptionError(
        'Erro ao reprovar a solicitação de matrícula',
      ));
    }
  }

  Future<void> requestSubscription(String classId) async {
    try {
      emit(RequestingSubscriptionState());
      await _subsRepository.create(Subscription(
        classId: classId,
        subscriberId: _authCubit.signedUser!.id,
        subscriptionStage: SubscriptionStage.requested,
        requestDate: DateTime.now(),
      ));
      _loadSubscriptionsCubit.load();
      emit(SubscriptionRequestedState());
    } catch (e) {
      print(e);
      _globalAlertCubit.fire(
        e is FirebaseCustomError ? e.message : 'Erro ao solicitar inscrição',
        isErrorMessage: true,
      );
      emit(RequestSubscriptionErrorState());
    }
  }
}
