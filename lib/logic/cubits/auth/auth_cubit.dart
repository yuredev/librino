import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/data/repositories/auth_repository.dart';
import 'package:librino/data/repositories/user/firestore_user_repository.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';

// TODO: converter em HydratedCubit?    (pesquisar como funciona as sessões do Firebase, se são para sempre)
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository = Bindings.get();
  final FirestoreUserRepository _firestoreUserRepository = Bindings.get();
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();

  AuthCubit() : super(LoggedOutState());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      emit(LoggingInState());
      final fireAuthUser =
          await _authRepository.signIn(email: email, password: password);
      final firestoreUser = await _firestoreUserRepository.getById(
        fireAuthUser.uid,
      );
      _globalAlertCubit.fire(
        'Bem vind${firestoreUser.genderIdentity == GenderIdentity.woman ? 'a' : 'o'} ${fireAuthUser.displayName}',
      );
      final user = LibrinoUser(
        auditoryAbility: firestoreUser.auditoryAbility,
        email: fireAuthUser.email!,
        id: fireAuthUser.uid,
        profileType: firestoreUser.roles == [0, 1]
            ? ProfileType.instructor
            : ProfileType.studant,
        name: fireAuthUser.displayName!,
        surname: firestoreUser.surname,
        genderIdentity: firestoreUser.genderIdentity,
        photoURL: fireAuthUser.photoURL,
      );
      emit(LoggedInState(user));
    } catch (e) {
      print(e);
      late final String message;
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          message = 'Nenhuma conta com este email foi encontrada';
        } else if (e.code == 'wrong-password') {
          message = 'Credenciais inválidas';
        } else {
          message = 'Erro inesperado ao realizar o login';
        }
      } else {
        message = 'Erro inesperado ao realizar o login';
      }
      emit(LoginErrorState(message));
    }
  }

  Future<void> signOut() async {
    try {
      final userName = (state as LoggedInState).user.name;
      emit(LoggingOutState());
      await _authRepository.signOut();
      _globalAlertCubit.fire('Tchau $userName! volte sempre');
      emit(LoggedOutState());
    } catch (e) {
      print(e);
      _globalAlertCubit.fire('Erro ao sair da sessão');
      emit(LoginErrorState('Erro ao sair da sessão'));
    }
  }
}
