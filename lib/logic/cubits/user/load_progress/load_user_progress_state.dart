// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:librino/data/models/user_progress/user_progress.dart';

abstract class LoadUserProgressState extends Equatable {
  const LoadUserProgressState();
}

class InitialUserProgressState extends LoadUserProgressState {
  const InitialUserProgressState();

  @override
  List<Object?> get props => [];
}

class LoadingUserProgressState extends LoadUserProgressState {
  const LoadingUserProgressState();

  @override
  List<Object?> get props => [];
}

class UserProgressLoadedState extends LoadUserProgressState {
  final List<UserProgress> progressList;

  const UserProgressLoadedState(this.progressList);

  @override
  List<Object?> get props => [progressList];
}

class LoadUserProgressErrorState extends LoadUserProgressState {
  final String errorMessage;

  const LoadUserProgressErrorState(
    this.errorMessage,
  );

  @override
  List<Object?> get props => [errorMessage];
}
