import 'package:equatable/equatable.dart';
import 'package:librino/data/models/user/librino_user.dart';

abstract class UserActionsState extends Equatable {
  const UserActionsState();
}

class UserCRUDInitialState extends UserActionsState {
  @override
  List<Object?> get props => [];
}

class CreatingUserState extends UserActionsState {
  @override
  List<Object?> get props => [];
}

class UserCreatedState extends UserActionsState {
  final LibrinoUser user;

  const UserCreatedState(this.user);

  @override
  List<Object?> get props => [user];
}

class ErrorCreatingUserState extends UserActionsState {
  final String message;

  const ErrorCreatingUserState(this.message);

  @override
  List<Object?> get props => [message];
}

class RemovingAccountState extends UserActionsState {
  @override
  List<Object?> get props => [];
}

class AccountRemovedState extends UserActionsState {
  @override
  List<Object?> get props => [];
}

class ErrorRemovingAccountState extends UserActionsState {
  final String message;

  const ErrorRemovingAccountState(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdatingUserState extends UserActionsState {
  @override
  List<Object?> get props => [];
}

class UserUpdatedState extends UserActionsState {
  final LibrinoUser user;

  const UserUpdatedState(this.user);

  @override
  List<Object?> get props => [user];
}

class ErrorUpdatingUserState extends UserActionsState {
  final String message;

  const ErrorUpdatingUserState(this.message);

  @override
  List<Object?> get props => [message];
}
