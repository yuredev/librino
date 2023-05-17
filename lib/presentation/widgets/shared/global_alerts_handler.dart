import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_state.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';

class GlobalAlertsHandler extends StatelessWidget {
  final Widget? child;

  const GlobalAlertsHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GlobalAlertCubit>.value(
      value: Bindings.get(),
      child: BlocListener<GlobalAlertCubit, GlobalAlertState>(
        listenWhen: (_, state) => state is GlobalAlertEmittedState,
        listener: (ctx, state) {
          PresentationUtils.showSnackBar(
            ctx,
            (state as GlobalAlertEmittedState).message,
            isErrorMessage: state.isErrorMessage,
          );
        },
        child: child,
      ),
    );
  }
}
