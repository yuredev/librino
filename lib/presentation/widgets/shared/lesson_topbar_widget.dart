import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/progress_bar_widget.dart';

class LessonTopBarWidget extends StatelessWidget {
  final int lifesNumber;
  final double progression;

  const LessonTopBarWidget({
    super.key,
    required this.lifesNumber,
    required this.progression,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: InkWell(
            onTap: () async {
              final deveSair = await PresentationUtils.showYesNotDialog(
                    context,
                    title: 'Deseja sair?',
                    description: 'Você perderá o progresso neste exercício',
                  ) ??
                  false;
              if (deveSair && context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Tooltip(
              message: 'Fechar',
              child: const Icon(
                Icons.close,
                color: LibrinoColors.iconGray,
                size: 30,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ProgressBarWidget(
              color: LibrinoColors.main,
              progression: progression,
              height: 18,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(
                right: 1.5,
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 26,
              ),
            ),
            Text(
              lifesNumber.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        )
      ],
    );
  }
}
