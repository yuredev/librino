import 'package:equatable/equatable.dart';

abstract class SubscriptionActionsState extends Equatable {
  const SubscriptionActionsState();
}

class InitialSubscriptionActionsState extends SubscriptionActionsState {
  @override
  List<Object?> get props => [];
}

class RequestingSubscriptionState extends SubscriptionActionsState {
  @override
  List<Object?> get props => [];
}

class SubscriptionRequestedState extends SubscriptionActionsState {
  @override
  List<Object?> get props => [];
}

class RequestSubscriptionErrorState extends SubscriptionActionsState {
  @override
  List<Object?> get props => [];
}

class ApprovingSubscriptionState extends SubscriptionActionsState {
  @override
  List<Object?> get props => [];
}

class SubscriptionApprovedState extends SubscriptionActionsState {
  @override
  List<Object?> get props => [];
}

class ApproveSubscriptionError extends SubscriptionActionsState {
  final String errorMessage;

  const ApproveSubscriptionError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class RepprovingSubscriptionState extends SubscriptionActionsState {
  @override
  List<Object?> get props => [];
}

class SubscriptionRepprovedState extends SubscriptionActionsState {
  @override
  List<Object?> get props => [];
}


class RepproveSubscriptionError extends SubscriptionActionsState {
  final String errorMessage;

  const RepproveSubscriptionError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

