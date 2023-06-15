import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/logic/cubits/lesson/actions/lesson_actions_cubit.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:lottie/lottie.dart';

class LessonResultScreen extends StatefulWidget {
  final bool hasFailed;
  final String lessonId;

  const LessonResultScreen({
    super.key,
    required this.hasFailed,
    required this.lessonId,
  });

  @override
  State<LessonResultScreen> createState() => _LessonResultScreenState();
}

class _LessonResultScreenState extends State<LessonResultScreen> {
  late final LessonActionsCubit lessonActionsCubit = context.read();

  @override
  void initState() {
    super.initState();
    if (!widget.hasFailed) {
      lessonActionsCubit.complete(widget.lessonId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LibrinoScaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Sizes.defaultScreenHorizontalMargin,
          Sizes.defaultScreenBottomMargin,
          Sizes.defaultScreenHorizontalMargin,
          Sizes.defaultScreenBottomMargin * 2,
        ),
        child: LayoutBuilder(
          builder: (context, consts) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Center(
                  child: SizedBox(
                    width: consts.maxWidth * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.hasFailed
                              ? 'Fim de jogo'
                              : 'Prática concluída',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: widget.hasFailed
                                ? Colors.red
                                : LibrinoColors.main,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: Text(
                            widget.hasFailed ? 'Tente novamente!' : 'Parabéns!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: LibrinoColors.subtitleGray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Lottie.asset(
                    widget.hasFailed
                        ? 'assets/animations/missed.json'
                        : 'assets/animations/win.json',
                    width: widget.hasFailed ? consts.maxWidth : null,
                  ),
                ),
              ),
              Spacer(),
              ButtonWidget(
                title: 'Continuar',
                onPress: () => Navigator.pop(context),
                width: double.infinity,
                height: Sizes.defaultButtonHeight,
              )
            ],
          ),
        ),
      ),
    );
  }
}
