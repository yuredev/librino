import 'package:equatable/equatable.dart';
import 'package:librino/data/models/user/librino_user.dart';

abstract class LoadParticipantsState extends Equatable {
  const LoadParticipantsState();
}

class InitialLoadParticipantsState extends LoadParticipantsState {
  @override
  List<Object?> get props => [];
}

class LoadingParticipantsState extends LoadParticipantsState {
  @override
  List<Object?> get props => [];
}

class LoadParticipantsErrorState extends LoadParticipantsState {
  final String message;

  const LoadParticipantsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class ParticipantsLoadedState extends LoadParticipantsState {
  final List<LibrinoUser> participants;

  const ParticipantsLoadedState(this.participants);

  @override
  List<Object?> get props => [participants];
}
