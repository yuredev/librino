// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/question/phrase_to_libras/phrase_to_libras_question.dart';
import 'package:librino/logic/cubits/question/actions/question_actions_cubit.dart';
import 'package:librino/logic/cubits/question/actions/question_actions_state.dart';
import 'package:librino/logic/validators/create_libras_to_phrase_validator.dart';
import 'package:librino/logic/validators/create_phrase_to_libras_validator.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:librino/presentation/widgets/shared/select_image_source_modal.dart';
import 'package:reorderables/reorderables.dart';

const ffmpegSuccessCode = 0;

class CreatePhraseToLIBRASScreen extends StatefulWidget {
  const CreatePhraseToLIBRASScreen({super.key});

  @override
  State<CreatePhraseToLIBRASScreen> createState() =>
      _CreatePhraseToLIBRASScreenState();
}

class _CreatePhraseToLIBRASScreenState
    extends State<CreatePhraseToLIBRASScreen> {
  final ffmpeg = FlutterFFmpeg();
  late final QuestionActionsCubit actionsCubit = context.read();
  final formKey = GlobalKey<FormState>();
  final statementCtrl = TextEditingController();
  final answerFiles = <XFile>[];
  var isPublicQuestion = false;
  String? statementErrorMessage;
  String? answerFilesErrorMessage;

  @override
  void dispose() {
    super.dispose();
    statementCtrl.dispose();
  }

  void submit() {
    setState(() {
      answerFilesErrorMessage =
          CreatePhraseToLIBRASValidator.validateAnswerFiles(answerFiles);
    });

    if (formKey.currentState!.validate() &&
        answerFilesErrorMessage == null &&
        statementErrorMessage == null) {
      actionsCubit.createLIBRASToPhrase(
        PhraseToLibrasQuestion(
          statement: statementCtrl.text,
          type: QuestionType.phraseToLibras,
          isPublic: isPublicQuestion,
        ),
        answerFiles,
      );
    }
  }

  void onActionsListen(BuildContext context, QuestionActionsState state) {
    if (state is QuestionCreatedState) {
      Navigator.pop(context, state.question);
    }
  }

  void attachVideo() async {
    FocusScope.of(context).unfocus();
    final shouldGetFromGallery = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SelectImageSourceModal(
        title: 'Adicionar vídeo',
        firstOption: 'Gravar vídeo',
      ),
    );
    if (shouldGetFromGallery == null) {
      return;
    }
    final pickedVideo = await Bindings.get<ImagePicker>().pickVideo(
      source: shouldGetFromGallery ? ImageSource.gallery : ImageSource.camera,
    );
    if (pickedVideo == null) return;
    final gifPath = pickedVideo.path.replaceAll('.mp4', '.gif');
    PresentationUtils.showLockedLoading(context, text: 'Anexando vídeo...');
    final result = await ffmpeg.execute(
      '-i ${pickedVideo.path} $gifPath',
    );
    Navigator.pop(context);
    if (result == ffmpegSuccessCode) {
      setState(() {
        answerFiles.add(XFile(gifPath));
      });
      PresentationUtils.showToast('Vídeo anexado');
    } else {
      PresentationUtils.showSnackBar(
        context,
        'Erro ao anexar vídeo',
        isErrorMessage: true,
      );
    }
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
      appBar: AppBar(
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Criar Questão',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.defaultScreenHorizontalMargin - 6,
          vertical: Sizes.defaultScreenTopMargin,
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '*Enunciado da questão: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 38),
                child: TextFormField(
                  controller: statementCtrl,
                  validator: CreateLIBRASToPhraseValidator.validateStatement,
                  autocorrect: false,
                  style: TextStyle(fontSize: 15),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: LibrinoColors.backgroundWhite,
                    prefixIcon: const Icon(
                      Icons.translate,
                      size: 22,
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 22, top: 12, bottom: 12),
                    label: const Text('Preencha o enunciado'),
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
                margin: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '*Resposta do exercício: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Text(
                  statementErrorMessage ??
                      'Anexe pequenas partes de vídeos em LIBRAS para que juntas formem a frase de resposta ao seu enunciado.',
                  style: TextStyle(
                    color: LibrinoColors.subtitleGray,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Row(
                  children: [
                    Text(
                      statementErrorMessage ?? 'Nota: ',
                      style: TextStyle(
                        color: LibrinoColors.textLightBlack,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      statementErrorMessage ??
                          'Ordene os vídeos na ordem correta da frase!',
                      style: TextStyle(
                        color: LibrinoColors.subtitleGray,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              LayoutBuilder(
                builder: (ctx, constraints) => ReorderableWrap(
                  spacing: 16,
                  runSpacing: 16,
                  onReorder: (oldIndex, newIndex) {
                    final aux = answerFiles[oldIndex];
                    setState(() {
                      answerFiles[oldIndex] = answerFiles[newIndex];
                      answerFiles[newIndex] = aux;
                    });
                  },
                  needsLongPressDraggable: false,
                  buildDraggableFeedback: (ctx, consts, widget) {
                    return Material(
                      borderRadius: BorderRadius.circular(25),
                      child: Transform.scale(
                        scaleX: 1.1,
                        scaleY: 1.1,
                        child: widget,
                      ),
                    );
                  },
                  footer: DottedBorder(
                    padding: EdgeInsets.zero,
                    color: LibrinoColors.grayInputBorder,
                    strokeWidth: 1.2,
                    dashPattern: [2.5, 2],
                    radius: Radius.circular(20),
                    borderType: BorderType.RRect,
                    child: Tooltip(
                      message: 'Anexar vídeo',
                      child: InkWellWidget(
                        onTap: attachVideo,
                        borderRadius: 20,
                        child: Container(
                          width: constraints.maxWidth * .301842904,
                          height: constraints.maxWidth * .301842904,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.add,
                            color: LibrinoColors.iconGrayDarker,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  alignment: WrapAlignment.spaceBetween,
                  children: answerFiles.map(
                    (e) {
                      return Stack(
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            width: constraints.maxWidth * .301842904,
                            height: constraints.maxWidth * .301842904,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            child: Image.file(
                              File(e.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red,
                              ),
                              child: InkWellWidget(
                                borderRadius: 20,
                                onTap: () {
                                  setState(() => answerFiles.remove(e));
                                  PresentationUtils.showToast('Vídeo removido');
                                },
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: FittedBox(
                                        child: Icon(Icons.close,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 38),
                child: answerFilesErrorMessage == null
                    ? SizedBox()
                    : Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Text(
                          answerFilesErrorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: LibrinoColors.validationErrorRed,
                            fontSize: 13,
                          ),
                        ),
                      ),
              ),
              Container(
                margin: EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() => isPublicQuestion = !isPublicQuestion);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: Checkbox(
                          value: isPublicQuestion,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => isPublicQuestion = value);
                          },
                        ),
                      ),
                      const Text('Questão pública')
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 50,
                  bottom: 16,
                ),
                child: BlocConsumer<QuestionActionsCubit, QuestionActionsState>(
                  listener: onActionsListen,
                  builder: (context, actionsState) => ButtonWidget(
                    title: 'Cadastrar',
                    height: Sizes.defaultButtonHeight,
                    width: double.infinity,
                    onPress: submit,
                    loadingText: 'Cadastrando...',
                    isLoading: actionsState is CreatingQuestionState,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
