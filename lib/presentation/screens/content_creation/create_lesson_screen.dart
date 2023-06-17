import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/lesson/lesson.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/data/models/question/question.dart';
import 'package:librino/logic/cubits/lesson/actions/lesson_actions_cubit.dart';
import 'package:librino/logic/cubits/lesson/actions/lesson_actions_state.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_cubit.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_state.dart';
import 'package:librino/logic/validators/create_lesson_validator.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/dotted_button.dart';
import 'package:librino/presentation/widgets/shared/list_tile_widget.dart';
import 'package:reorderables/reorderables.dart';

class CreateLessonScreen extends StatefulWidget {
  final Module module;
  final int lessonCreationIndex;

  const CreateLessonScreen({
    super.key,
    required this.module,
    required this.lessonCreationIndex,
  });

  @override
  State<CreateLessonScreen> createState() => _CreateLessonScreenState();
}

class _CreateLessonScreenState extends State<CreateLessonScreen> {
  late final ModuleActionsCubit moduleActionsCubit = context.read();
  late final LessonActionsCubit lessonActionsCubit = context.read();
  final nameCtrl = TextEditingController();
  final indexCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final questions = <Question>[];
  String? questionListErrorMsg;
  String? supportContentId;

  void submit(BuildContext context) async {
    setState(() {
      questionListErrorMsg = CreateLessonValidator.validateQuestions(questions);
    });
    if (formKey.currentState!.validate() && questionListErrorMsg == null) {
      PresentationUtils.showLockedLoading(context, text: 'Salvando lição...');
      await lessonActionsCubit.create(
        Lesson(
          title: nameCtrl.text,
          index: widget.lessonCreationIndex,
          questionIds: questions.map((e) => e.id!).toList(),
          moduleId: widget.module.id!,
        ),
      );
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
    FocusScope.of(context).unfocus();
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
      floatingActionButton:
          BlocListener<LessonActionsCubit, LessonActionsState>(
        listener: (context, state) {
          if (state is LessonCreatedState) {
            Navigator.pop(context); // locked loading
            Navigator.pop(context, state.lesson);
          } else if (state is CreateLessonErrorState) {
            Navigator.pop(context); // locked loading
          }
        },
        child: FloatingActionButton.extended(
          onPressed: () => submit(context),
          icon: const Icon(Icons.save),
          label: const Text(
            'Salvar',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
      backgroundColor: LibrinoColors.backgroundGray,
      appBar: AppBar(
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Cadastrar Lição',
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
                    'Informações básicas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.5,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 48),
                  child: TextFormField(
                    controller: nameCtrl,
                    validator: CreateLessonValidator.validateName,
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
                // Container(
                //   margin: const EdgeInsets.only(bottom: 48),
                //   child: TextFormField(
                //     controller: indexCtrl,
                //     validator: CreateLessonValidator.validateIndex,
                //     autocorrect: false,
                //     style: TextStyle(fontSize: 15),
                //     textInputAction: TextInputAction.next,
                //     keyboardType: TextInputType.numberWithOptions(signed: true),
                //     decoration: InputDecoration(
                //       filled: true,
                //       fillColor: LibrinoColors.backgroundWhite,
                //       prefixIcon: const Icon(
                //         Icons.filter_1,
                //         size: 22,
                //       ),
                //       contentPadding: const EdgeInsets.only(left: 22),
                //       label: const Text('*Ordem da lição no módulo da turma'),
                //       enabledBorder: inputBorder,
                //       disabledBorder: inputBorder,
                //       focusedBorder: inputBorder,
                //       border: inputBorder,
                //       labelStyle: TextStyle(
                //         color: LibrinoColors.grayPlaceholder,
                //       ),
                //       isDense: true,
                //     ),
                //   ),
                // ),
                // TODO: funcionalidade a ser implementada no futuro?
                if (false)
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
                    'Questões da lição',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.5,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        bottom: questions.isNotEmpty ? 38 : 0,
                      ),
                      child: ReorderableColumn(
                        onReorder: (oldIndex, newIndex) {
                          final aux = questions[oldIndex];
                          setState(() {
                            questions[oldIndex] = questions[newIndex];
                            questions[newIndex] = aux;
                          });
                        },
                        children: questions.asMap().entries.map((entry) {
                          final q = entry.value;
                          final i = entry.key;
                          return Container(
                            key: ValueKey(
                              i.toString() + DateTime.now().toString(),
                            ),
                            padding: EdgeInsets.only(bottom: 12),
                            child: ListTileWidget(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.previewQuestion,
                                  arguments: {
                                    'question': q,
                                    'readOnly': true,
                                  },
                                );
                              },
                              onDelete: () async {
                                final shouldDelete =
                                    await PresentationUtils.showYesNotDialog(
                                          context,
                                          title: 'Remover questão?',
                                          description: q.isPublic
                                              ? 'A questão será removida da lição.\nNo entanto ainda é possível encontrá-la no banco de questões.'
                                              : 'Esta questão será permanentemente excluída',
                                        ) ??
                                        false;
                                if (shouldDelete) {
                                  setState(() => questions.remove(q));
                                  PresentationUtils.showToast(
                                    'Questão removida',
                                  );
                                }
                              },
                              title: '${i + 1} - ${q.label}',
                              subtitle: questionTypeToString[q.type],
                              borderRadius: Sizes.defaultInputBorderRadius,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    DottedButton(
                      fillColor: LibrinoColors.backgroundWhite,
                      borderColor: questionListErrorMsg == null
                          ? LibrinoColors.grayInputBorder
                          : LibrinoColors.validationErrorRed,
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
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 38),
                  child: questionListErrorMsg == null
                      ? SizedBox()
                      : Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Text(
                            questionListErrorMsg!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: LibrinoColors.validationErrorRed,
                              fontSize: 13,
                            ),
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
