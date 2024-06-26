import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/data/models/lesson/lesson.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/logic/cubits/class/select/select_class_state.dart';
import 'package:librino/logic/cubits/module/load/load_modules_cubit.dart';
import 'package:librino/logic/cubits/module/load/load_modules_state.dart';
import 'package:librino/logic/cubits/question/load_questions/load_lesson_questions_cubit.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/learning_overview/create_module_content_modal.dart';
import 'package:librino/presentation/widgets/learning_overview/lesson_modal_widget.dart';
import 'package:librino/presentation/widgets/learning_overview/module_grid_item_widget.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';

class ModulesGridWidget extends StatefulWidget {
  const ModulesGridWidget({super.key});

  @override
  State<ModulesGridWidget> createState() => _ModulesGridWidgetState();
}

class _ModulesGridWidgetState extends State<ModulesGridWidget> {
  Module? module;

  void openLessonModal(Module module, Lesson lesson, bool isCompleted) {
    PresentationUtils.showBottomModal(
      context,
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<LoadLessonQuestionsCubit>()),
          BlocProvider.value(value: context.read<AuthCubit>())
        ],
        child: LessonModalWidget(
          lesson,
          module: module,
          readOnly: isCompleted,
        ),
      ),
    );
  }

  int getCompletedsCount(List<Lesson> all, List<String> completed) {
    return all.where((l) => completed.contains(l.id)).length;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, consts) {
        return BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (previous, current) => current is LoggedInState,
          builder: (context, authState) {
            final completedLessons =
                (authState as LoggedInState).user.completedLessonsIds;
            return BlocBuilder<LoadModulesCubit, LoadModulesState>(
              builder: (context, state) {
                if (state is HomeModulesListLoaded) {
                  return state.modules.isEmpty
                      ? BlocBuilder<SelectClassCubit, SelectClassState>(
                          builder: (context, state) => IllustrationWidget(
                            illustrationName: 'no-data.png',
                            title: 'Sem resultados',
                            subtitle: state.clazz == null
                                ? 'Nenhuma turma foi selecionada. Selecione uma turma para ver seu conteúdo'
                                : 'Parece que não há nada postado aqui',
                            imageWidth: consts.maxWidth * .47,
                          ),
                        )
                      : GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 22,
                          children: state.modules.map(
                            (m) {
                              return ModuleGridItemWidget(
                                onPress: () {
                                  setState(() => module = m);
                                  if (m.lessons!.isNotEmpty) {
                                    final currentLessonIndex =
                                        m.lessons!.indexWhere(
                                      (lesson) =>
                                          !completedLessons.contains(lesson.id),
                                    );
                                    openLessonModal(
                                      m,
                                      currentLessonIndex == -1
                                          ? m.lessons!.first
                                          : m.lessons![currentLessonIndex],
                                      currentLessonIndex == -1,
                                    );
                                  } else {
                                    PresentationUtils.showBottomModal(
                                      context,
                                      CreateModuleContentModal(module: m),
                                    );
                                  }
                                },
                                title: m.title,
                                subtitle: authState.user.isInstructor
                                    ? '${m.lessons!.length} ${m.lessons!.length == 1 ? 'Lição' : 'Lições'}'
                                    : null,
                                conclusionPercentage: m.lessons!.isEmpty
                                    ? 0
                                    : getCompletedsCount(
                                          m.lessons!,
                                          completedLessons,
                                        ) /
                                        m.lessons!.length *
                                        100,
                                imageUrl: m.imageUrl,
                              );
                            },
                          ).toList(),
                        );
                }
                if (state is HomeModulesListError) {
                  return IllustrationWidget(
                    illustrationName: 'error.json',
                    isAnimation: true,
                    title: state.message,
                    imageWidth: consts.maxWidth * 0.49,
                    textImageSpacing: 0,
                  );
                }
                return GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 22,
                  children: List.generate(
                    6,
                    (index) => ModuleGridItemWidget(
                      isLoading: true,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
