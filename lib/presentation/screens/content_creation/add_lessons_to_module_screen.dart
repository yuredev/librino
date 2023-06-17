import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/lesson/lesson.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/logic/cubits/lesson/actions/lesson_actions_cubit.dart';
import 'package:librino/logic/cubits/lesson/actions/lesson_actions_state.dart';
import 'package:librino/logic/cubits/lesson/load/load_lessons_cubit.dart';
import 'package:librino/logic/cubits/lesson/load/load_lesson_state.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/dotted_button.dart';
import 'package:librino/presentation/widgets/shared/list_tile_widget.dart';
import 'package:reorderables/reorderables.dart';

class AddLessonsToModuleScreen extends StatefulWidget {
  final Module module;

  const AddLessonsToModuleScreen({
    super.key,
    required this.module,
  });

  @override
  State<AddLessonsToModuleScreen> createState() =>
      _AddLessonsToModuleScreenState();
}

class _AddLessonsToModuleScreenState extends State<AddLessonsToModuleScreen> {
  late final LoadLessonsCubit loadLessonsCubit = context.read();
  late final LessonActionsCubit lessonActionsCubit = context.read();
  final lessons = <Lesson>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LibrinoColors.backgroundGray,
      appBar: AppBar(
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Adicionar Lições',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocListener<LessonActionsCubit, LessonActionsState>(
        listenWhen: (previous, current) =>
            current is LessonsOrderUpdatedState ||
            current is UpdatingLessonsOrderState,
        listener: (context, state) {
          if (state is LessonsOrderUpdatedState) {
            PresentationUtils.showToast('Alterações salvas');
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            Sizes.defaultScreenHorizontalMargin,
            Sizes.defaultScreenTopMargin - 10,
            Sizes.defaultScreenHorizontalMargin,
            Sizes.defaultScreenBottomMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 22),
                child: const Text(
                  'Lições do módulo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.5,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(bottom: lessons.isNotEmpty ? 38 : 0),
                    child: ReorderableColumn(
                      onReorder: (oldIndex, newIndex) {
                        final aux = lessons[oldIndex];
                        setState(() {
                          lessons[oldIndex] = lessons[newIndex];
                          lessons[newIndex] = aux;
                          lessons[oldIndex] =
                              lessons[oldIndex].copyWith(index: oldIndex);
                          lessons[newIndex] =
                              lessons[newIndex].copyWith(index: newIndex);
                        });
                        lessonActionsCubit.reorder(lessons);
                      },
                      children: lessons.asMap().entries.map(
                        (entry) {
                          final l = entry.value;
                          final index = entry.key;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            key: ValueKey(l.id!),
                            child: ListTileWidget(
                              title: '${index + 1} - ${l.title}',
                              subtitle:
                                  '${l.questionIds.length} exercícios${l.supportContentId != null ? ' + conteúdo de apoio' : ''}',
                              onDelete: () async {
                                final shouldRemove =
                                    (await PresentationUtils.showYesNotDialog(
                                          context,
                                          title: 'Remover lição?',
                                          description:
                                              'O conteúdo desta lição será perdido e não poderá ser recuperado',
                                        )) ??
                                        false;
                                if (shouldRemove) {
                                  setState(() => lessons.remove(l));
                                  PresentationUtils.showToast(
                                    'Lição removida',
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  DottedButton(
                    fillColor: LibrinoColors.backgroundWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                    title: 'Adicionar Lição',
                    onPress: () async {
                      final lesson = (await Navigator.pushNamed(
                        context,
                        Routes.createLesson,
                        arguments: {
                          'module': widget.module,
                          'lessonCreationIndex': lessons.length,
                        },
                      ) as Lesson?);
                      if (lesson == null) return;
                      setState(() => lessons.add(lesson));
                      PresentationUtils.showToast('Lição adicionada');
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
