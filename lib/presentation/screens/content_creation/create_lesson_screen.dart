import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/question/question.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_cubit.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_state.dart';
import 'package:librino/logic/validators/create_module_validator.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/dotted_button.dart';
import 'package:librino/presentation/widgets/shared/list_tile_widget.dart';

class CreateLessonScreen extends StatefulWidget {
  const CreateLessonScreen({
    super.key,
  });

  @override
  State<CreateLessonScreen> createState() => _CreateLessonScreenState();
}

class _CreateLessonScreenState extends State<CreateLessonScreen> {
  late final ModuleActionsCubit moduleActionsCubit = context.read();
  final nameCtrl = TextEditingController();
  final indexCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? supportContentId;
  final questions = <Question>[];

  void submit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }

  void onModuleActionsListen(BuildContext context, ModuleActionsState state) {
    if (state is ModuleCreatedState) {
      Navigator.pushNamed(context, Routes.addLessonsToModule, arguments: {
        'module': state.module,
      });
    }
  }

  void onAddQuestionPress() async {
    final newQuestion = (await Navigator.pushNamed(
      context,
      Routes.addQuestionToLesson,
    )) as Question?;
    if (newQuestion == null) return;
    setState(() {
      questions.add(newQuestion);
    });
    PresentationUtils.showToast('Questão adicionada');
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
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Adicionar Lições - Nova Lição',
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
                  margin: const EdgeInsets.only(bottom: 22),
                  child: const Text(
                    'Lição',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.5,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: nameCtrl,
                    validator: CreateModuleValidator.validateName,
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
                      label: const Text('*Nome da lição'),
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
                    controller: indexCtrl,
                    validator: CreateModuleValidator.validateIndex,
                    autocorrect: false,
                    style: TextStyle(fontSize: 15),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: LibrinoColors.backgroundWhite,
                      prefixIcon: const Icon(
                        Icons.filter_1,
                        size: 22,
                      ),
                      contentPadding: const EdgeInsets.only(left: 22),
                      label: const Text('*Ordem da lição no módulo da turma'),
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
                  margin: const EdgeInsets.only(bottom: 48),
                  child: Tooltip(
                    message: 'Adicionar conteúdo de apoio para a lição',
                    // TODO: adicionar preview do conteúdo de suporte?
                    child: DottedButton(
                      fillColor: LibrinoColors.backgroundWhite,
                      borderColor: supportContentId == null
                          ? LibrinoColors.iconGrayDarker
                          : LibrinoColors.main,
                      title: supportContentId == null
                          ? 'Conteúdo de Apoio'
                          : 'Conteúdo de Apoio Anexado',
                      titleColor: supportContentId == null
                          ? LibrinoColors.grayPlaceholder
                          : LibrinoColors.main,
                      icon: Container(
                        margin: const EdgeInsets.only(right: 5, bottom: 3),
                        child: Icon(
                          supportContentId == null
                              ? Icons.menu_book_sharp
                              : Icons.done,
                          color: supportContentId == null
                              ? LibrinoColors.iconGrayDarker
                              : LibrinoColors.main,
                        ),
                      ),
                      onPress: () {},
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 22),
                  child: const Text(
                    'Questões',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.5,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final q = questions[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTileWidget(
                              title: q.label,
                              subtitle: questionTypeToString[q.type],
                              icon: Icons.sign_language_outlined,
                              borderRadius: Sizes.defaultInputBorderRadius,
                            ),
                          );
                        },
                      ),
                    ),
                    DottedButton(
                      fillColor: LibrinoColors.backgroundWhite,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      icon: Container(
                        margin: const EdgeInsets.only(
                          right: 4,
                          bottom: 1.2,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: LibrinoColors.iconGrayDarker,
                        ),
                      ),
                      title: 'Adicionar Questão',
                      onPress: onAddQuestionPress,
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 70),
                  child: ButtonWidget(
                    title: 'Adicionar Lição',
                    width: double.infinity,
                    height: Sizes.defaultButtonHeight,
                    onPress: () => submit(context),
                    padding: const EdgeInsets.symmetric(vertical: 14),
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