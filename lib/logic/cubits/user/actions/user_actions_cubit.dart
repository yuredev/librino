import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/data/models/user/firestore_user.dart';
import 'package:librino/data/repositories/auth_repository.dart';
import 'package:librino/data/repositories/class_repository.dart';
import 'package:librino/data/repositories/module_repository.dart';
import 'package:librino/data/repositories/question_repository.dart';
import 'package:librino/data/repositories/subscription_repository.dart';
import 'package:librino/data/repositories/user/fireauth_user_repository.dart';
import 'package:librino/data/repositories/user/firestore_user_repository.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/user/actions/user_actions_state.dart';

class UserActionsCubit extends Cubit<UserActionsState> {
  final FireAuthUserRepository _fireAuthRepository = Bindings.get();
  final FirestoreUserRepository _firestoreRepository = Bindings.get();
  final ModuleRepository _moduleRepository = Bindings.get();
  final ClassRepository _classRepository = Bindings.get();
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();
  final QuestionRepository _questionRepository = Bindings.get();
  final AuthCubit _authCubit = Bindings.get();
  final AuthRepository _authRepository = Bindings.get();
  final SubscriptionRepository _subscriptionRepository = Bindings.get();

  UserActionsCubit() : super(UserCRUDInitialState());

  Future<void> create({
    required String email,
    required String name,
    required String surname,
    required String password,
    required AuditoryAbility auditoryAbility,
    required ProfileType profileType,
    GenderIdentity? genderIdentity,
    XFile? photo,
  }) async {
    try {
      emit(CreatingUserState());
      name = name.replaceRange(0, 1, name[0].toUpperCase());
      surname = surname.replaceRange(0, 1, surname[0].toUpperCase());
      final fireAuthUser = await _fireAuthRepository.create(
        name: name,
        email: email,
        password: password,
        photo: photo,
      );
      final firestoreUser = await _firestoreRepository.save(
        FirestoreUser(
          id: fireAuthUser.uid,
          auditoryAbility: auditoryAbility,
          roles: profileType == ProfileType.instructor ? [0, 1] : [0],
          genderIdentity: genderIdentity,
          surname: surname,
          name: name,
          email: email,
          photoUrl: fireAuthUser.photoURL,
        ),
      );
      final completedUser = LibrinoUser(
        auditoryAbility: auditoryAbility,
        id: fireAuthUser.uid,
        email: email,
        photoURL: fireAuthUser.photoURL,
        profileType: profileType,
        genderIdentity: firestoreUser.genderIdentity,
        name: fireAuthUser.displayName!,
        surname: firestoreUser.surname,
        completedLessonsIds: [],
      );
      _globalAlertCubit.fire('Conta criada com sucesso!');
      emit(UserCreatedState(completedUser));
    } catch (e) {
      print(e);
      late final String message;
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          message = 'A senha fornecida é muito fraca';
        } else if (e.code == 'email-already-in-use') {
          message = 'Já existe uma conta vinculada á este email';
        } else {
          message = 'Erro inesperado ao criar usuário';
        }
      } else {
        message = 'Erro inesperado ao criar usuário';
      }
      _globalAlertCubit.fire(message, isErrorMessage: true);
      emit(ErrorCreatingUserState(message));
    }
  }

  Future<void> update(LibrinoUser user, XFile? photo) async {
    try {
      emit(UpdatingUserState());
      final photoUrl = await _fireAuthRepository.update(user, photo);
      final userWithPhoto = user.copyWith(photoURL: photoUrl);
      await _firestoreRepository.update(userWithPhoto);
      _globalAlertCubit.fire('Dados atualizados com sucesso!');
      emit(UserUpdatedState(userWithPhoto));
    } catch (e) {
      print(e);
      _globalAlertCubit.fire(
        'Erro ao atualizar os dados do usuário',
        isErrorMessage: true,
      );
      emit(ErrorUpdatingUserState('Erro ao atualizar os dados do usuário'));
    }
  }

  Future<void> removeAccount(String password) async {
    emit(RemovingAccountState());
    final user = _authCubit.signedUser!;
    try {
      await _authRepository.signIn(email: user.email, password: password);
    } catch (e) {
      emit(ErrorRemovingAccountState('Credenciais invalídas!'));
      return;
    }
    try {
      final classes = await _classRepository.getFromInstructor(user.id);
      final subscriptions = await (user.isInstructor
          ? _subscriptionRepository.getByResponsibleId(user.id)
          : _subscriptionRepository.getBySubscriberId(user.id));

      for (final sub in subscriptions) {
        await _subscriptionRepository.delete(sub.id);
      }
      for (final clazz in classes) {
        final classModules = await _moduleRepository.getFromClass(clazz.id!);
        for (final module in classModules) {
          await _moduleRepository.delete(module.id);
        }
        await _classRepository.delete(clazz.id);
      }
      await _fireAuthRepository.removeAccount();
      await _firestoreRepository.removeAccount(_authCubit.signedUser!.id);
      await _questionRepository
          .deletePrivatesFromUser(_authCubit.signedUser!.id);
      _authCubit.signOut(showMessage: false);
      emit(AccountRemovedState());
    } catch (e) {
      _globalAlertCubit.fire('Erro ao remover conta!', isErrorMessage: true);
      emit(ErrorRemovingAccountState('Erro ao remover conta!'));
    }
  }
}
