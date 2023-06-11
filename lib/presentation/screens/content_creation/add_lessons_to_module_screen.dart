import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/lesson/lesson.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/logic/cubits/lesson/load/load_lessons_cubit.dart';
import 'package:librino/logic/cubits/lesson/load/load_single_lesson_cubit.dart';
import 'package:librino/logic/cubits/lesson/load/load_lesson_state.dart';
import 'package:librino/presentation/widgets/shared/dotted_button.dart';
import 'package:librino/presentation/widgets/shared/refreshable_scrollview_widget.dart';

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
  final lessonsAdded = <Lesson>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadLessonsCubit.loadFromModule(widget.module.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BlocBuilder<LoadLessonsCubit, LoadLessonState>(
        builder: (context, state) => RefreshableScrollViewWidget(
          onRefresh: () => loadLessonsCubit.loadFromModule(widget.module.id!),
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
                  'Lições',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.5,
                  ),
                ),
              ),
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: lessonsAdded.length,
                    itemBuilder: (context, index) {
                      final l = lessonsAdded[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: ListTile(
                          title: Text('${l.number} ${l.title}'),
                          subtitle: Text(
                            '13 exercícios${l.supportContentId != null ? ' + conteúdo de apoio' : ''}',
                          ),
                        ),
                      );
                    },
                  ),
                  DottedButton(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    icon: Container(
                      margin: const EdgeInsets.only(
                        right: 4,
                        bottom: 1.2,
                      ),
                      child: Icon(
                        Icons.add,
                        color: LibrinoColors.iconGrayDarker,
                      ),
                    ),
                    title: 'Adicionar Lição',
                    onPress: () {
                      Navigator.pushNamed(context, Routes.createLesson);
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
