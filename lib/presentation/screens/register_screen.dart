import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/user/actions/user_actions_cubit.dart';
import 'package:librino/logic/cubits/user/actions/user_actions_state.dart';
import 'package:librino/logic/validators/register_user_validator.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:librino/presentation/widgets/shared/select_image_source_modal.dart';

class RegisterScreen extends StatefulWidget {
  final bool isEdit;

  const RegisterScreen({
    super.key,
    this.isEdit = false,
  });

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
  XFile? photo;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) populateFields();
  }

  void populateFields() {
    final u = authCubit.signedUser!;
    nameCtrl.text = u.name;
    surnameCtrl.text = u.surname;
    genderIdentity = u.genderIdentity;
    auditoryAbility = u.auditoryAbility;
  }

  void submitUpdate(BuildContext context) {
    setState(() {
      genderIdentityErrorMsg =
          RegisterUserValidator.validateGenderIdentity(genderIdentity);
      auditoryAbilityErrorMsg =
          RegisterUserValidator.validateAuditoryAbility(auditoryAbility);
    });
    if (formKey.currentState!.validate() &&
        [
          genderIdentityErrorMsg,
          auditoryAbilityErrorMsg,
        ].every((e) => e == null)) {
      context.read<UserActionsCubit>().update(
            authCubit.signedUser!
                .copyWith(
                  auditoryAbility: auditoryAbility,
                  surname: surnameCtrl.text,
                  name: nameCtrl.text,
                  genderIdentity: genderIdentity,
                )
                .copyWithout(
                  genderIdentity: genderIdentity == null,
                ),
            photo,
          );
    }
  }

  void submitCreation(BuildContext context) {
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
      context.read<UserActionsCubit>().create(
            email: emailCtrl.text,
            auditoryAbility: auditoryAbility!,
            name: nameCtrl.text,
            password: passwordCtrl.text,
            profileType: profileType!,
            surname: surnameCtrl.text,
            genderIdentity: genderIdentity,
            photo: photo,
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

  void attachPhoto() async {
    FocusScope.of(context).unfocus();
    final shouldGetFromGallery = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SelectImageSourceModal(),
    );
    if (shouldGetFromGallery == null) {
      return;
    }
    final pickedImage = await Bindings.get<ImagePicker>().pickImage(
      source: shouldGetFromGallery ? ImageSource.gallery : ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (pickedImage != null && context.mounted) {
      setState(() {
        photo = pickedImage;
      });
    }
  }

  void onUserActionsListen(BuildContext context, UserActionsState state) async {
    if (state is UserCreatedState) {
      await Future.delayed(Duration(milliseconds: 500), () {});
      if (context.mounted) {
        PresentationUtils.showLockedLoading(
          context,
          text: 'Entrando na conta...',
        );
      }
      if (context.mounted) {
        await Future.delayed(Duration(seconds: 1), () {});
        authCubit.signIn(
          email: state.user.email,
          password: passwordCtrl.text,
        );
      }
    } else if (state is UserUpdatedState) {
      authCubit.updateUserState(state.user);
      Navigator.pop(context);
    }
  }

  Widget buildPhotoBtn() {
    final screenSize = MediaQuery.of(context).size;
    const addPhotoBtnSize = 35.0;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: addPhotoBtnSize / 2),
          clipBehavior: Clip.antiAlias,
          width: screenSize.width * 0.34,
          height: screenSize.width * 0.34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(120),
          ),
          child: photo != null
              ? Image.file(
                  File(photo!.path),
                  fit: BoxFit.cover,
                )
              : widget.isEdit && authCubit.signedUser!.photoURL != null
                  ? Image.network(
                      authCubit.signedUser!.photoURL!,
                      fit: BoxFit.cover,
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: LibrinoColors.mainDeeper.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(120),
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          left: -0.07,
                          child: Icon(
                            Icons.person,
                            size: screenSize.width * 0.34,
                            color: LibrinoColors.backgroundWhite,
                          ),
                        ),
                        Positioned(
                          bottom: -80,
                          child: Icon(
                            Icons.circle,
                            size: screenSize.width * 0.34,
                            color: LibrinoColors.backgroundWhite,
                          ),
                        ),
                      ],
                    ),
        ),
        Positioned(
          bottom: 2,
          child: Container(
            width: addPhotoBtnSize,
            height: addPhotoBtnSize,
            decoration: BoxDecoration(
              color: LibrinoColors.mainLighter,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Tooltip(
              message: photo != null ||
                      widget.isEdit && authCubit.signedUser!.photoURL != null
                  ? 'Editar foto'
                  : 'Adicionar foto',
              child: InkWellWidget(
                borderRadius: 50,
                onTap: attachPhoto,
                child: Padding(
                  padding: EdgeInsets.all(photo != null ||
                          widget.isEdit &&
                              authCubit.signedUser!.photoURL != null
                      ? 8.0
                      : 4.0),
                  child: FittedBox(
                    child: Icon(
                      photo != null ||
                              widget.isEdit &&
                                  authCubit.signedUser!.photoURL != null
                          ? Icons.edit
                          : Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
      backgroundColor: LibrinoColors.backgroundGray,
      appBar: AppBar(
        backgroundColor: LibrinoColors.mainDeeper,
        centerTitle: true,
        title: Text(
          widget.isEdit ? 'Editar perfil' : 'Cadastrar-se',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
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
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 28),
                  child: buildPhotoBtn(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Informações cadastrais',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
              if (!widget.isEdit)
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
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
                  if (!widget.isEdit) const SizedBox(width: 12),
                  if (!widget.isEdit)
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
              if (!widget.isEdit)
                const Divider(
                    thickness: 1, height: Sizes.defaultScreenTopMargin),
              if (!widget.isEdit)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    'Credenciais',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                ),
              if (!widget.isEdit)
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
              if (!widget.isEdit)
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
                    textInputAction: TextInputAction.done,
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
                      labelStyle:
                          TextStyle(color: LibrinoColors.grayPlaceholder),
                      isDense: true,
                    ),
                  ),
                ),
              if (!widget.isEdit)
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
                child: BlocConsumer<UserActionsCubit, UserActionsState>(
                  listenWhen: (previous, current) => [
                    CreatingUserState,
                    UpdatingUserState,
                    UserCreatedState,
                    UserUpdatedState,
                    ErrorUpdatingUserState,
                    ErrorCreatingUserState,
                  ].contains(current.runtimeType),
                  listener: onUserActionsListen,
                  builder: (context, state) => ButtonWidget(
                    title: widget.isEdit ? 'Atualizar' : 'Cadastrar',
                    width: double.infinity,
                    height: Sizes.defaultButtonHeight,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    onPress: () => widget.isEdit
                        ? submitUpdate(context)
                        : submitCreation(context),
                    isLoading: state is CreatingUserState ||
                        state is UpdatingUserState,
                    loadingText:
                        widget.isEdit ? 'Atualizando' : 'Submetendo...',
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
