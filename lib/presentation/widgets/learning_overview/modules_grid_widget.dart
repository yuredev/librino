import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/logic/cubits/lesson/lesson_state.dart';
import 'package:librino/logic/cubits/lesson/load_lesson_cubit.dart';
import 'package:librino/logic/cubits/module/load_modules_cubit.dart';
import 'package:librino/logic/cubits/module/module_state.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/learning_overview/lesson_modal_widget.dart';
import 'package:librino/presentation/widgets/learning_overview/module_grid_item_widget.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';

class ModulesGridWidget extends StatefulWidget {
  const ModulesGridWidget({super.key});

  @override
  State<ModulesGridWidget> createState() => _ModulesGridWidgetState();
}

class _ModulesGridWidgetState extends State<ModulesGridWidget> {
  late final LoadLessonCubit loadLessonCubit = context.read();
  Module? module;

  void onLoadLesson(BuildContext context, LessonState state) {
    if (state is LessonLoadError) {
      Navigator.pop(context); // loading
      PresentationUtils.showSnackBar(context, state.message);
    } else if (state is LessonLoaded) {
      Navigator.pop(context); // loading
      PresentationUtils.showBottomModal(
        context,
        LessonModalWidget(state.lesson, module: module!),
      );
    } else if (state is LoadinglLesson) {
      PresentationUtils.showLockedLoading(
        context,
        text: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoadLessonCubit, LessonState>(
      listener: onLoadLesson,
      child: LayoutBuilder(
        builder: (_, consts) {
          return BlocBuilder<LoadModulesCubit, ModuleState>(
            builder: (context, state) {
              if (state is HomeModulesListLoaded) {
                return state.modules.isEmpty
                    ? IllustrationWidget(
                        illustrationName: 'no-data.png',
                        title: 'Sem resultados',
                        subtitle:
                            'Parece que não há conteúdo na turma selecionada',
                        imageWidth: consts.maxWidth * 0.7,
                      )
                    : GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 22,
                        children: state.modules
                            .map(
                              (m) => ModuleGridItemWidget(
                                onPress: () {
                                  setState(() {
                                    module = m;
                                  });
                                  loadLessonCubit.loadLesson(
                                    'ZuNAujmyuUYeRfJdJKdi',
                                    m.id,
                                    0,
                                  );
                                },
                                title: m.title,
                                conclusionPercentage: 65,
                                imageUrl: m.imageUrl,
                              ),
                            )
                            .toList(),
                      );
              }
              if (state is HomeModulesListError) {
                return IllustrationWidget(
                  illustrationName: 'no-internet.json',
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
      ),
    );
  }
}
