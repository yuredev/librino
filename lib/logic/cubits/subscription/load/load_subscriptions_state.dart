import 'package:equatable/equatable.dart';

import 'package:librino/data/models/subscription/subscription.dart';

abstract class LoadSubscriptionsState extends Equatable {
  const LoadSubscriptionsState();
}

class InitialLoadSubscriptionsState extends LoadSubscriptionsState {
  const InitialLoadSubscriptionsState();

  @override
  List<Object?> get props => [];
}

class LoadingSubcriptionsState extends LoadSubscriptionsState {
  const LoadingSubcriptionsState();

  @override
  List<Object?> get props => [];
}

class SubscriptionsLoadedState extends LoadSubscriptionsState {
  final List<Subscription> subscriptions;

  const SubscriptionsLoadedState(this.subscriptions);

  @override
  List<Object?> get props => [subscriptions];
}

class LoadSubscriptionsErrorState extends LoadSubscriptionsState {
  final String errorMessage;

  const LoadSubscriptionsErrorState(this.errorMessage);

  @override
  List<Object?> get props => [];
}
