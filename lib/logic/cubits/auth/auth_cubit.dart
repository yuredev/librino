import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/constants/storage_keys.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/data/repositories/auth_repository.dart';
import 'package:librino/data/repositories/user/firestore_user_repository.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';

// TODO: pesquisar como funciona as sessões do Firebase, se são para sempre
class AuthCubit extends HydratedCubit<AuthState> {
  final AuthRepository _authRepository = Bindings.get();
  final FirestoreUserRepository _firestoreUserRepository = Bindings.get();
  final SelectClassCubit _selectClassCubit = Bindings.get();
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();

  AuthCubit() : super(LoggedOutState());

  LibrinoUser? get signedUser {
    if (state is LoggedInState) {
      return (state as LoggedInState).user;
    } else {
      return null;
    }
  }

  void updateUserState(LibrinoUser user) => emit(
        LoggedInState(user, (state as LoggedInState).token),
      );

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
        profileType: firestoreUser.roles.contains(1)
            ? ProfileType.instructor
            : ProfileType.studant,
        name: fireAuthUser.displayName ?? firestoreUser.name,
        surname: firestoreUser.surname,
        genderIdentity: firestoreUser.genderIdentity,
        photoURL: fireAuthUser.photoURL,
        completedLessonsIds: firestoreUser.completedLessonsIds ?? [],
      );
      emit(LoggedInState(user, fireAuthUser.refreshToken!));
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

  Future<void> signOut({bool showMessage = true}) async {
    try {
      final userName = (state as LoggedInState).user.name;
      emit(LoggingOutState());
      await _authRepository.signOut();
      _selectClassCubit.select(null);
      if (showMessage) _globalAlertCubit.fire('Tchau $userName! volte sempre');
      emit(LoggedOutState());
    } catch (e) {
      print(e);
      if (showMessage) _globalAlertCubit.fire('Erro ao sair da sessão');
      emit(LoginErrorState('Erro ao sair da sessão'));
    }
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    if (![json[StorageKeys.signedUser], json[StorageKeys.token]]
        .contains(null)) {
      return LoggedInState(
        LibrinoUser.fromJson(json[StorageKeys.signedUser]),
        json[StorageKeys.token],
      );
    }
    return LoggedOutState();
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is LoggedInState) {
      return {
        StorageKeys.signedUser: state.user.toJson(),
        StorageKeys.token: state.token,
      };
    }
    return {
      StorageKeys.signedUser: null,
      StorageKeys.token: null,
    };
  }
}
