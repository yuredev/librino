import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_state.dart';

class GlobalAlertCubit extends Cubit<GlobalAlertState> {
  GlobalAlertCubit() : super(InitialGlobalAlertState());

  void fire(String message, {bool isErrorMessage = false}) {
    emit(GlobalAlertEmittedState(
      message,
      isErrorMessage: isErrorMessage,
    ));
  }
}
