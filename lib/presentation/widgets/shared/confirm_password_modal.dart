import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/logic/cubits/user/actions/user_actions_cubit.dart';
import 'package:librino/logic/cubits/user/actions/user_actions_state.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/modal_top_bar_widget.dart';

class ConfirmPasswordModal extends StatefulWidget {
  const ConfirmPasswordModal({super.key});

  @override
  State<ConfirmPasswordModal> createState() => _ConfirmPasswordModalState();
}

class _ConfirmPasswordModalState extends State<ConfirmPasswordModal> {
  late final UserActionsCubit userCRUDCubit = Bindings.get();
  final passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void submit() {
    if (formKey.currentState!.validate()) {
      userCRUDCubit.removeAccount(passwordCtrl.text);
    }
  }

  void onUserCRUDListen(BuildContext context, UserActionsState state) {
    if (state is RemovingAccountState) {
      PresentationUtils.showLockedLoading(
        context,
        text: 'Removendo conta...',
      );
    } else if (state is AccountRemovedState) {
      Navigator.pop(context); // Modal
      Navigator.pushReplacementNamed(context, Routes.login);
      PresentationUtils.showSnackBar(
        context,
        'Conta removida com sucesso!',
      );
    } else if (state is ErrorRemovingAccountState) {
      Navigator.pop(context); // Modal
      PresentationUtils.showSnackBar(
        context,
        state.message,
        isErrorMessage: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const topBarSpacing = 17.0;
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: LibrinoColors.grayInputBorder,
      ),
      borderRadius: BorderRadius.circular(Sizes.defaultInputBorderRadius),
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: topBarSpacing, horizontal: 24),
      height: MediaQuery.of(context).size.height * .55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: topBarSpacing,
              ),
              child: const ModalTopBarWidget(),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 16, 18, 16),
            child: Text(
              'Confirme a senha',
              style: TextStyle(
                color: LibrinoColors.main,
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Form(
            key: formKey,
            child: TextFormField(
              controller: passwordCtrl,
              validator: (text) {
                if (text?.isEmpty ?? true) {
                  return 'Preencha a senha';
                }
                return null;
              },
              onFieldSubmitted: (_) => submit(),
              autocorrect: false,
              style: TextStyle(fontSize: 15),
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.name,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: LibrinoColors.backgroundWhite,
                prefixIcon: const Icon(
                  Icons.lock,
                  size: 22,
                ),
                contentPadding: const EdgeInsets.only(left: 22),
                label: const Text('Confirme a senha'),
                enabledBorder: inputBorder,
                disabledBorder: inputBorder,
                focusedBorder: inputBorder,
                border: inputBorder,
                labelStyle: TextStyle(
                  color: LibrinoColors.grayPlaceholder,
                ),
                isDense: true,
              ),
            ),
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.only(
              bottom: 13,
            ),
            child: BlocConsumer<UserActionsCubit, UserActionsState>(
              listenWhen: (previous, current) {
                if (previous is RemovingAccountState) {
                  Navigator.pop(context);
                  passwordCtrl.clear();
                }
                return [
                  RemovingAccountState,
                  AccountRemovedState,
                  ErrorRemovingAccountState,
                ].contains(current.runtimeType);
              },
              listener: onUserCRUDListen,
              builder: (context, state) => ButtonWidget(
                title: 'Confirmar',
                width: double.infinity,
                height: Sizes.defaultButtonHeight,
                onPress: submit,
                isLoading: state is RemovingAccountState,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          )
        ],
      ),
    );
  }
}
