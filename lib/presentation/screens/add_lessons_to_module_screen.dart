import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/logic/cubits/lesson/load/load_single_lesson_cubit.dart';
import 'package:librino/logic/cubits/lesson/load/load_lesson_state.dart';

class AddLessonsToModuleScreen extends StatefulWidget {
  const AddLessonsToModuleScreen({super.key});

  @override
  State<AddLessonsToModuleScreen> createState() =>
      _AddLessonsToModuleScreenState();
}

class _AddLessonsToModuleScreenState extends State<AddLessonsToModuleScreen> {
  late final LoadSingleLessonCubit loadLessonCubit = context.read();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
      loadLessonCubit.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Lições do Módulo',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              Sizes.defaultScreenHorizontalMargin,
              Sizes.defaultScreenTopMargin - 10,
              Sizes.defaultScreenHorizontalMargin,
              Sizes.defaultScreenBottomMargin,
            ),
            child: BlocBuilder<LoadSingleLessonCubit, LoadLessonState>(
              builder: (context, state) => Column(
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
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
