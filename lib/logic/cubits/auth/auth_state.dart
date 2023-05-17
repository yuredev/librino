// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:librino/data/models/user/librino_user.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class LoggingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoggedOutState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoggedInState extends AuthState {
  final LibrinoUser user;

  const LoggedInState(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginErrorState extends AuthState {
  final String message;

  const LoginErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
