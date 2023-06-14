import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/user/user_crud_cubit.dart';
import 'package:librino/logic/cubits/user/user_crud_state.dart';
import 'package:librino/logic/validators/register_user_validator.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// TODO: adicionar upload de foto no cadastro
class _RegisterScreenState extends State<RegisterScreen> {
  late final authCubit = context.read<AuthCubit>();
  final passwordCtrl = TextEditingController();
  final passwordConfirmCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final surnameCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var passwordIsVisible = false;
  var inputGenderHasChanged = false;
  AuditoryAbility? auditoryAbility;
  GenderIdentity? genderIdentity;
  ProfileType? profileType;
  // TODO: colocar mensagens de erro na tela
  String? genderIdentityErrorMsg;
  String? profileTypeErrorMsg;
  String? auditoryAbilityErrorMsg;

  void submit(BuildContext context) {
    setState(() {
      genderIdentityErrorMsg =
          RegisterUserValidator.validateGenderIdentity(genderIdentity);
      profileTypeErrorMsg =
          RegisterUserValidator.validateProfileType(profileType);
      auditoryAbilityErrorMsg =
          RegisterUserValidator.validateAuditoryAbility(auditoryAbility);
    });
    if (formKey.currentState!.validate() &&
        [
          genderIdentityErrorMsg,
          profileTypeErrorMsg,
          auditoryAbilityErrorMsg,
        ].every((e) => e == null)) {
      context.read<UserCRUDCubit>().create(
            email: emailCtrl.text,
            auditoryAbility: auditoryAbility!,
            name: nameCtrl.text,
            password: passwordCtrl.text,
            profileType: profileType!,
            surname: surnameCtrl.text,
            genderIdentity: genderIdentity,
          );
    }
  }

  Widget buildInputLayout({
    required Widget child,
    required String label,
    String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 3),
          child: Text(
            label,
            style: TextStyle(
              color: LibrinoColors.subtitleGray,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child,
        if (errorMessage != null)
          Container(
            margin: const EdgeInsets.only(top: 8, left: 22),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: LibrinoColors.validationErrorRed,
                fontSize: 12.6,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: LibrinoColors.grayInputBorder,
      ),
      borderRadius: BorderRadius.circular(Sizes.defaultInputBorderRadius),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Cadastrar-se',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          Sizes.defaultScreenHorizontalMargin,
          Sizes.defaultScreenTopMargin - 10,
          Sizes.defaultScreenHorizontalMargin,
          Sizes.defaultScreenBottomMargin,
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Informações cadastrais',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  autocorrect: false,
                  validator: RegisterUserValidator.validateName,
                  controller: nameCtrl,
                  style: TextStyle(fontSize: 16),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: LibrinoColors.backgroundWhite,
                    prefixIcon: const Icon(
                      Icons.person_2_outlined,
                      size: 22,
                    ),
                    contentPadding: const EdgeInsets.only(left: 22),
                    label: const Text('*Nome'),
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
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  validator: RegisterUserValidator.validateSurname,
                  autocorrect: false,
                  controller: surnameCtrl,
                  style: TextStyle(fontSize: 16),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: LibrinoColors.backgroundWhite,
                    prefixIcon: const Icon(
                      Icons.person_2_outlined,
                      size: 22,
                    ),
                    contentPadding: const EdgeInsets.only(left: 22),
                    label: const Text('*Sobrenome'),
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
              TextFormField(
                autocorrect: false,
                controller: emailCtrl,
                validator: RegisterUserValidator.validateEmail,
                style: const TextStyle(fontSize: 16),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: LibrinoColors.backgroundWhite,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    size: 22,
                  ),
                  contentPadding: const EdgeInsets.only(left: 22),
                  label: const Text('*Email'),
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
              Divider(thickness: 1, height: Sizes.defaultScreenTopMargin),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Identificação do usuário',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: buildInputLayout(
                  label: 'Gênero:',
                  errorMessage: genderIdentityErrorMsg,
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: LibrinoColors.backgroundWhite,
                      border: Border.all(
                        color: genderIdentityErrorMsg == null
                            ? LibrinoColors.grayInputBorder
                            : LibrinoColors.validationErrorRed,
                      ),
                      borderRadius: BorderRadius.circular(
                        Sizes.defaultInputBorderRadius,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<GenderIdentity>(
                        selectedItemBuilder: (context) => GenderIdentity.values
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Text(
                                      genderIdentityToString[e]!,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ))
                            .toList()
                          ..add(DropdownMenuItem(
                            child: Container(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                'Selecionar',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: LibrinoColors.grayPlaceholder,
                                ),
                              ),
                            ),
                          )),
                        value: genderIdentity,
                        onChanged: (value) {
                          setState(() {
                            genderIdentity = value;
                            // inputGenderHasChanged = true;
                          });
                        },
                        hint: Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Selecionar',
                            style: TextStyle(
                              fontSize: 14,
                              color: LibrinoColors.grayPlaceholder,
                            ),
                          ),
                        ),
                        items: GenderIdentity.values
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Text(
                                      genderIdentityToString[e]!,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ))
                            .toList()
                          ..add(DropdownMenuItem(
                            child: Container(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                'Prefiro não informar',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          )),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: buildInputLayout(
                      label: '*Condição auditiva:',
                      errorMessage: auditoryAbilityErrorMsg,
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: genderIdentityErrorMsg == null
                              ? LibrinoColors.backgroundWhite
                              : LibrinoColors.validationErrorRed,
                          border: Border.all(
                            color: auditoryAbilityErrorMsg == null
                                ? LibrinoColors.grayInputBorder
                                : LibrinoColors.validationErrorRed,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.defaultInputBorderRadius,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<AuditoryAbility>(
                            value: auditoryAbility,
                            onChanged: (value) {
                              setState(() => auditoryAbility = value);
                            },
                            hint: Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                'Selecionar',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: LibrinoColors.grayPlaceholder,
                                ),
                              ),
                            ),
                            items: AuditoryAbility.values
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 12),
                                        child: Text(
                                          audityAbilityToString[e]!,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: buildInputLayout(
                      errorMessage: profileTypeErrorMsg,
                      label: '*Perfil:',
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: LibrinoColors.backgroundWhite,
                          border: Border.all(
                            color: profileTypeErrorMsg == null
                                ? LibrinoColors.grayInputBorder
                                : LibrinoColors.validationErrorRed,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.defaultInputBorderRadius,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ProfileType>(
                            value: profileType,
                            onChanged: (value) {
                              setState(() => profileType = value);
                            },
                            hint: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: FittedBox(
                                child: const Text(
                                  'Selecionar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: LibrinoColors.grayPlaceholder,
                                  ),
                                ),
                              ),
                            ),
                            items: ProfileType.values
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        child: Text(
                                          profileTypeToString[e]!,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1, height: Sizes.defaultScreenTopMargin),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Credenciais',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  autocorrect: false,
                  validator: RegisterUserValidator.validatePassword,
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
                        passwordIsVisible
                            ? Icons.lock_open_outlined
                            : Icons.lock_outline,
                        size: 22,
                      ),
                      onPressed: () => setState(() {
                        passwordIsVisible = !passwordIsVisible;
                      }),
                    ),
                    contentPadding: const EdgeInsets.only(left: 22),
                    label: const Text('*Senha'),
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
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  autocorrect: false,
                  validator: (b) =>
                      RegisterUserValidator.validatePasswordConfirm(
                    passwordCtrl.text,
                    b,
                  ),
                  controller: passwordConfirmCtrl,
                  style: const TextStyle(fontSize: 16),
                  enableSuggestions: false,
                  textInputAction: TextInputAction.next,
                  obscureText: !passwordIsVisible,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: LibrinoColors.backgroundWhite,
                    prefixIcon: IconButton(
                      icon: Icon(
                        passwordIsVisible
                            ? Icons.lock_open_outlined
                            : Icons.lock_outline,
                        size: 22,
                      ),
                      onPressed: () => setState(() {
                        passwordIsVisible = !passwordIsVisible;
                      }),
                    ),
                    contentPadding: const EdgeInsets.only(left: 22),
                    label: const Text('*Confirmar Senha'),
                    enabledBorder: inputBorder,
                    disabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    border: inputBorder,
                    labelStyle: TextStyle(color: LibrinoColors.grayPlaceholder),
                    isDense: true,
                  ),
                ),
              ),
              BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is LoggedInState) {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, Routes.home);
                  } else if (state is LoginErrorState) {
                    Navigator.pushReplacementNamed(context, Routes.login);
                  }
                },
                child: SizedBox(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 46),
                child: BlocConsumer<UserCRUDCubit, UserCRUDState>(
                  listenWhen: (previous, current) =>
                      current is UserCreatedState,
                  listener: (context, state) async {
                    if (state is UserCreatedState) {
                      await Future.delayed(Duration(milliseconds: 500), () {});
                      if (context.mounted) {
                        PresentationUtils.showLockedLoading(
                          context,
                          text: 'Entrando na conta...',
                        );
                      }
                      await Future.delayed(Duration(seconds: 1), () {});
                      if (context.mounted) {
                        authCubit.signIn(
                          email: state.user.email,
                          password: passwordCtrl.text,
                        );
                      }
                    }
                  },
                  builder: (context, state) => ButtonWidget(
                    title: 'Cadastrar',
                    width: double.infinity,
                    height: Sizes.defaultButtonHeight,
                    onPress: () => submit(context),
                    isLoading: state is CreatingUserState,
                    loadingText: 'Submetendo...',
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
