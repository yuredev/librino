abstract class GlobalAlertState {}

class InitialGlobalAlertState implements GlobalAlertState {}

class GlobalAlertEmittedState implements GlobalAlertState {
  final String message;
  final bool isErrorMessage;

  const GlobalAlertEmittedState(this.message, {this.isErrorMessage = false});
}
