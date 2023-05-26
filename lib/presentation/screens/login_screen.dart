import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/validators/login_validator.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  var hidePassword = true;
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final passwordFocus = FocusNode();
  var errorMessage = '';
  var passwordIsVisible = false;
  late final authCubit = context.read<AuthCubit>();

  void onAuthListen(BuildContext context, AuthState state) {
    if (state is LoggedInState) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else if (state is LoginErrorState) {
      setState(() => errorMessage = state.message);
    }
  }

  void trySignIn() {
    if (formKey.currentState!.validate()) {
      authCubit.signIn(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: LibrinoColors.grayInputBorder,
      ),
      borderRadius: BorderRadius.circular(Sizes.defaultInputBorderRadius),
    );
    return LibrinoScaffold(
      backgroundColor: LibrinoColors.backgroundGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 22.5),
              child: Image.asset(
                'assets/images/signals.png',
                width: MediaQuery.of(context).size.width * .6,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 35),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: LibrinoColors.mainDeeper,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 7.5),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 12.8,
                          color: LibrinoColors.subtitleGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        validator: LoginValidator.validateEmail,
                        autocorrect: false,
                        controller: emailCtrl,
                        style: TextStyle(fontSize: 16),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          passwordFocus.requestFocus();
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: LibrinoColors.backgroundWhite,
                          prefixIcon: const Icon(
                            Icons.email,
                            size: 22,
                          ),
                          contentPadding: const EdgeInsets.only(left: 22),
                          hintText: 'Insira seu email',
                          enabledBorder: inputBorder,
                          disabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          border: inputBorder,
                          hintStyle: TextStyle(
                            color: LibrinoColors.grayPlaceholder,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 7.5),
                      child: Text(
                        'Senha',
                        style: TextStyle(
                          fontSize: 12.8,
                          color: LibrinoColors.subtitleGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 2),
                      child: TextFormField(
                        validator: LoginValidator.validatePassword,
                        focusNode: passwordFocus,
                        autocorrect: false,
                        controller: passwordCtrl,
                        style: const TextStyle(fontSize: 16),
                        enableSuggestions: false,
                        textInputAction: TextInputAction.next,
                        obscureText: !passwordIsVisible,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: LibrinoColors.backgroundWhite,
                          prefixIcon: IconButton(
                            icon: Icon(
                              passwordIsVisible ? Icons.lock_open : Icons.lock,
                              size: 22,
                            ),
                            onPressed: () => setState(() {
                              passwordIsVisible = !passwordIsVisible;
                            }),
                          ),
                          contentPadding: const EdgeInsets.only(left: 22),
                          hintText: 'Insira sua senha',
                          enabledBorder: inputBorder,
                          disabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          border: inputBorder,
                          isDense: true,
                          hintStyle: TextStyle(
                            color: LibrinoColors.grayPlaceholder,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 6),
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                        ),
                        onPressed: () => Navigator.pushNamed(
                          context,
                          Routes.register,
                        ),
                        child: Text(
                          'Não possui conta?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: onAuthListen,
                      builder: (context, state) {
                        return Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 40),
                              child: Center(
                                child: SizedBox(
                                  width: 250,
                                  child: Text(
                                    errorMessage,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 85),
                              child: ButtonWidget(
                                title: 'Entrar',
                                color: LibrinoColors.mainDeeper,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                onPress: () {
                                  if (state is! LoggingInState) {
                                    trySignIn();
                                  }
                                },
                                height: Sizes.defaultButtonHeight,
                                isLoading: state is LoggingInState,
                                loadingText: 'Entrando...',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
