import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/data/models/user/firestore_user.dart';
import 'package:librino/data/repositories/user/fireauth_user_repository.dart';
import 'package:librino/data/repositories/user/firestore_user_repository.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/user/user_crud_state.dart';

class UserCRUDCubit extends Cubit<UserCRUDState> {
  final FireAuthUserRepository _fireAuthRepository = Bindings.get();
  final FirestoreUserRepository _firestoreRepository = Bindings.get();
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();

  UserCRUDCubit() : super(UserCRUDInitialState());

  Future<void> create({
    required String email,
    required String name,
    required String surname,
    required String password,
    required AuditoryAbility auditoryAbility,
    required ProfileType profileType,
    GenderIdentity? genderIdentity,
  }) async {
    try {
      emit(CreatingUserState());
      name = name.replaceRange(0, 1, name[0].toUpperCase());
      surname = surname.replaceRange(0, 1, surname[0].toUpperCase());
      final fireAuthUser = await _fireAuthRepository.create(
        name: name,
        email: email,
        password: password,
      );
      final firestoreUser = await _firestoreRepository.save(
        FirestoreUser(
          id: fireAuthUser.uid,
          auditoryAbility: auditoryAbility,
          roles: profileType == ProfileType.instructor ? [0, 1] : [0],
          genderIdentity: genderIdentity,
          surname: surname,
        ),
      );
      _globalAlertCubit.fire('Conta criada com sucesso!');
      emit(
        UserCreatedState(LibrinoUser(
          auditoryAbility: auditoryAbility,
          id: fireAuthUser.uid,
          email: email,
          photoURL: fireAuthUser.photoURL,
          profileType: profileType,
          genderIdentity: firestoreUser.genderIdentity,
          name: fireAuthUser.displayName!,
          surname: firestoreUser.surname,
        )),
      );
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
}
