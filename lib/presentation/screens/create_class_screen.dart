import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/logic/cubits/class/actions/class_actions_cubit.dart';
import 'package:librino/logic/cubits/class/actions/class_actions_state.dart';
import 'package:librino/logic/validators/create_class_validator.dart';
import 'package:librino/presentation/screens/class_succefully_created_screen.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({super.key});

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  late final ClassActionsCubit classCRUDCubit = context.read();
  final formKey = GlobalKey<FormState>();

  void submit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      classCRUDCubit.create(
        Class(
          description: descriptionCtrl.text,
          name: nameCtrl.text,
        ),
      );
    }
  }

  void onClassCRUDListen(BuildContext context, ClassActionsState state) {
    if (state is ClassCreatedState) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ClassSuccefullyCreatedScreen(clazz: state.clazz);
          },
        ),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Cadastrar Turma',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
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
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: nameCtrl,
                    validator: CreateClassValidator.validateName,
                    autocorrect: false,
                    style: TextStyle(fontSize: 15),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: LibrinoColors.backgroundWhite,
                      prefixIcon: const Icon(
                        Icons.draw_outlined,
                        size: 22,
                      ),
                      contentPadding: const EdgeInsets.only(left: 22),
                      label: const Text('*Nome da turma'),
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
                    controller: descriptionCtrl,
                    validator: CreateClassValidator.validateDescription,
                    autocorrect: false,
                    style: TextStyle(fontSize: 15),
                    textInputAction: TextInputAction.send,
                    onFieldSubmitted: (_) => submit(context),
                    keyboardType: TextInputType.name,
                    maxLines: 3,
                    maxLength: 300,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: LibrinoColors.backgroundWhite,
                      prefixIcon: const Icon(
                        Icons.description_outlined,
                        size: 22,
                      ),
                      contentPadding:
                          const EdgeInsets.only(left: 22, top: 12, bottom: 12),
                      label: const Text('*Descrição'),
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
                  margin: const EdgeInsets.only(top: 46),
                  child: BlocConsumer<ClassActionsCubit, ClassActionsState>(
                    listener: onClassCRUDListen,
                    builder: (context, state) => ButtonWidget(
                      title: 'Cadastrar Turma',
                      width: double.infinity,
                      height: Sizes.defaultButtonHeight,
                      onPress: () => submit(context),
                      isLoading: state is CreatingClassState,
                      loadingText: 'Submetendo...',
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
