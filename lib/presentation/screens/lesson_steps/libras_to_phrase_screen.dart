import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/lesson_topbar_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:librino/presentation/widgets/shared/question_title.dart';
import 'package:librino/presentation/widgets/shared/video_player_widget.dart';
import 'package:reorderables/reorderables.dart';
import 'package:video_player/video_player.dart';

class LibrasToPhraseScreen extends StatefulWidget {
  const LibrasToPhraseScreen({super.key});

  @override
  State<LibrasToPhraseScreen> createState() => _LibrasToPhraseScreenState();
}

class _LibrasToPhraseScreenState extends State<LibrasToPhraseScreen> {
  late final VideoPlayerController videoCtrl;
  final palavrasSelecionadas = <String>[];
  final palavrasDisponiveis = <String>[
    'De',
    'Menina',
    'Noite',
    'Futebol',
    'Hollow',
    'Cachorro',
    'Cobra',
    'Mordeu',
    'O',
    'Menino',
  ];

  @override
  void initState() {
    super.initState();
    videoCtrl = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );
    initializeVideo();
  }

  Future<void> initializeVideo() async {
    await videoCtrl.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LibrinoScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(23, 40, 23, 0),
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 26,
                    ),
                    child: LessonTopBarWidget(lifesNumber: 5, progression: 75),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: const QuestionTitleWidget(
                      'Qual a tradução deste sinal em português?',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 26),
              color: LibrinoColors.backgroundGray,
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 64,
              //   vertical: 16,
              // ),
              // height: 100,
              width: double.infinity,
              child: VideoPlayerWidget(
                videoPath:
                    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(23, 0, 23, 0),
              child: Column(
                children: [
                  if (palavrasSelecionadas.isEmpty)
                    LayoutBuilder(
                      builder: (context, constraints) => Container(
                        margin: const EdgeInsets.only(bottom: 26),
                        width: constraints.maxWidth * .7,
                        child: Text(
                          'Toque nas palavras abaixo para formar a frase'
                          ' correspondente ao sinal do vídeo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: LibrinoColors.subtitleGray,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.only(bottom: 26),
                      child: ReorderableWrap(
                        needsLongPressDraggable: false,
                        buildDraggableFeedback: (ctx, consts, widget) {
                          return Material(
                            borderRadius: BorderRadius.circular(25),
                            child: Transform.scale(
                              scaleX: 1.15,
                              scaleY: 1.15,
                              child: widget,
                            ),
                          );
                        },
                        spacing: 7,
                        runSpacing: -4,
                        onReorder: (int oldIndex, int newIndex) {},
                        children: palavrasSelecionadas
                            .map(
                              (e) => Theme(
                                data: ThemeData(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      palavrasSelecionadas.remove(e);
                                    });
                                  },
                                  child: Chip(
                                    backgroundColor:
                                        LibrinoColors.backgroundWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                        color: LibrinoColors.borderGray,
                                      ),
                                    ),
                                    label: Text(
                                      e,
                                      style: TextStyle(
                                        color: LibrinoColors.textLightBlack,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(bottom: 26),
                    child: const Divider(height: 0, thickness: 1),
                  ),
                  Wrap(
                    spacing: 7,
                    runSpacing: -4,
                    children: palavrasDisponiveis.map(
                      (e) {
                        final isDisabled = palavrasSelecionadas.contains(e);
                        return Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (!palavrasSelecionadas.contains(e)) {
                                setState(() {
                                  palavrasSelecionadas.add(e);
                                });
                              }
                            },
                            child: Chip(
                              backgroundColor: isDisabled
                                  ? LibrinoColors.disabledGray
                                  : LibrinoColors.backgroundWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                  color: LibrinoColors.borderGray,
                                ),
                              ),
                              label: Text(
                                e,
                                style: TextStyle(
                                  color: isDisabled
                                      ? LibrinoColors.disabledGray
                                      : LibrinoColors.textLightBlack,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 50,
                      bottom: Sizes.defaultScreenBottomMargin,
                    ),
                    child: ButtonWidget(
                      title: 'Checar',
                      height: Sizes.defaultButtonSize,
                      width: double.infinity,
                      onPress: () {},
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
