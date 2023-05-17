import 'package:equatable/equatable.dart';
import 'package:librino/data/models/user/librino_user.dart';

abstract class UserCRUDState extends Equatable {
  const UserCRUDState();
}

class UserCRUDInitialState extends UserCRUDState {
  @override
  List<Object?> get props => [];
}

class CreatingUserState extends UserCRUDState {
  @override
  List<Object?> get props => [];
}

class UserCreatedState extends UserCRUDState {
  final LibrinoUser user;

  const UserCreatedState(this.user);

  @override
  List<Object?> get props => [user];
}

class ErrorCreatingUserState extends UserCRUDState {
  final String message;

  const ErrorCreatingUserState(this.message);

  @override
  List<Object?> get props => [message];
}
