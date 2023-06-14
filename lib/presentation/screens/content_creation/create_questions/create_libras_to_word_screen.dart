import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/random_words.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/question/libras_to_word/libras_to_word_question.dart';
import 'package:librino/logic/cubits/question/actions/question_actions_cubit.dart';
import 'package:librino/logic/cubits/question/actions/question_actions_state.dart';
import 'package:librino/logic/validators/create_libras_to_phrase_validator.dart';
import 'package:librino/logic/validators/create_libras_to_word_validator.dart';
import 'package:librino/presentation/screens/content_creation/preview_video_screen.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/add_word_modal.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/dotted_button.dart';
import 'package:librino/presentation/widgets/shared/select_image_source_modal.dart';

class CreateLIBRASToWordScreen extends StatefulWidget {
  const CreateLIBRASToWordScreen({super.key});

  @override
  State<CreateLIBRASToWordScreen> createState() =>
      _CreateLIBRASToWordScreenState();
}

class _CreateLIBRASToWordScreenState extends State<CreateLIBRASToWordScreen> {
  late final QuestionActionsCubit actionsCubit = context.read();
  final formKey = GlobalKey<FormState>();
  final statementCtrl = TextEditingController();
  final choices = <String>[];
  String? rightChoice;
  XFile? video;
  var isPublicQuestion = false;
  String? videoErrorMessage;
  String? choicesErrorMessage;
  String? rightChoiceErrorMessage;

  @override
  void initState() {
    super.initState();
    statementCtrl.text =
        'Qual a tradução em português escrito para a frase abaixo em LIBRAS?';
  }

  @override
  void dispose() {
    super.dispose();
    statementCtrl.dispose();
  }

  void attachVideo() async {
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
    if (pickedVideo != null && context.mounted) {
      final cofirmVideo = (await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PreviewVideoScreen(pickedVideo);
              },
            ),
          )) ??
          false;
      if (cofirmVideo) {
        setState(() => video = pickedVideo);
        PresentationUtils.showToast('Vídeo anexado');
      }
    }
  }

  void onAddWordTap() async {
    if (choices.length == 5) {
      PresentationUtils.showToast('Limite de palavras atingido!');
      return;
    }
    final word = await PresentationUtils.showBottomModal<String>(
        context, AddWordModal());
    if (word != null) {
      setState(() => choices.add(word));
      PresentationUtils.showToast('Palavra adicionada');
    }
  }

  void submit() {
    setState(() {
      choicesErrorMessage =
          CreateLIBRASToWordValidator.validateChoices(choices);
      videoErrorMessage = CreateLIBRASToWordValidator.validateVideo(video);
      rightChoiceErrorMessage =
          CreateLIBRASToWordValidator.validateRightChoice(rightChoice);
    });

    if (formKey.currentState!.validate() &&
        choicesErrorMessage == null &&
        videoErrorMessage == null &&
        rightChoiceErrorMessage == null) {
      actionsCubit.createLIBRASToWord(
        LibrasToWordQuestion(
          rightChoice: rightChoice!,
          choices: choices,
          type: QuestionType.librasToWord,
          statement: statementCtrl.text,
          isPublic: isPublicQuestion,
        ),
        video!,
      );
    }
  }

  void onActionsListen(BuildContext context, QuestionActionsState state) {
    if (state is QuestionCreatedState) {
      Navigator.pop(context, state.question);
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
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    errorMaxLines: 3,
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
                  '*Vídeo de sinal em LIBRAS: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: DottedButton(
                  padding: EdgeInsets.symmetric(vertical: 70),
                  borderColor: videoErrorMessage != null
                      ? LibrinoColors.validationErrorRed
                      : video != null
                          ? LibrinoColors.main
                          : LibrinoColors.iconGrayDarker,
                  title: video == null
                      ? '*Anexar vídeo - sinal em LIBRAS'
                      : 'Vídeo anexado',
                  titleColor: video == null
                      ? LibrinoColors.grayPlaceholder
                      : LibrinoColors.main,
                  onPress: attachVideo,
                  icon: Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Icon(
                      video == null ? Icons.videocam_outlined : Icons.done,
                      color: video == null
                          ? LibrinoColors.iconGrayDarker
                          : LibrinoColors.main,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 38),
                alignment: Alignment.center,
                child: LayoutBuilder(
                  builder: (context, constraints) => SizedBox(
                    width: constraints.maxWidth * .85,
                    child: Text(
                      videoErrorMessage ??
                          '*Anexe um vídeo de um sinal na '
                              'Língua Brasileira de Sinais (LIBRAS)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: videoErrorMessage == null
                            ? LibrinoColors.subtitleGray
                            : LibrinoColors.validationErrorRed,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '*Alternativas: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                child: LayoutBuilder(
                  builder: (context, constraints) => SizedBox(
                    child: const Text(
                      'Adicione 5 alternativas que serão exibidas ao usuário na hora do exercício.',
                      style: TextStyle(
                        color: LibrinoColors.subtitleGray,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: LayoutBuilder(
                  builder: (context, constraints) => SizedBox(
                    child: const Text(
                      'Uma delas deve ser a resposta correta ao vídeo em LIBRAS anexado.',
                      style: TextStyle(
                        color: LibrinoColors.subtitleGray,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Wrap(
                  spacing: 7,
                  runSpacing: -4,
                  children: choices.map(
                    (e) {
                      return Theme(
                        data: ThemeData(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: InkWell(
                          child: Chip(
                            onDeleted: () {
                              setState(() {
                                if (rightChoice == e) {
                                  rightChoice = null;
                                }
                                choices.remove(e);
                              });
                            },
                            deleteIcon: const Icon(
                              Icons.close,
                              color: LibrinoColors.iconGrayDarker,
                              size: 16,
                            ),
                            backgroundColor: LibrinoColors.backgroundWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                color: choicesErrorMessage == null
                                    ? LibrinoColors.borderGray
                                    : LibrinoColors.validationErrorRed,
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
                      );
                    },
                  ).toList(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: DottedButton(
                        title: 'Adicionar alternativa',
                        onPress: onAddWordTap,
                        fontSize: 13,
                        autoWidth: true,
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      ),
                    ),
                    Expanded(
                      child: DottedButton(
                        title: 'Aleatorizar',
                        onPress: () {
                          setState(() {
                            setState(() => rightChoice = null);
                            choices
                              ..clear()
                              ..addAll(RandomWords.getList(4));
                          });
                        },
                        fontSize: 13,
                        autoWidth: true,
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 38),
                child: choicesErrorMessage == null
                    ? SizedBox()
                    : Text(
                        choicesErrorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: LibrinoColors.validationErrorRed,
                          fontSize: 13,
                        ),
                      ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '*Alternativa correta: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: LibrinoColors.backgroundWhite,
                  border: Border.all(
                    color: rightChoiceErrorMessage == null
                        ? LibrinoColors.grayInputBorder
                        : LibrinoColors.validationErrorRed,
                  ),
                  borderRadius:
                      BorderRadius.circular(Sizes.defaultInputBorderRadius),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: rightChoice,
                    hint: Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Text(
                        'Selecionar',
                        style: TextStyle(
                          fontSize: 15,
                          color: LibrinoColors.grayPlaceholder,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          rightChoice = value;
                        });
                      }
                    },
                    items: choices
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              margin: const EdgeInsets.only(left: 12),
                              child: Text(
                                e,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 38),
                child: rightChoiceErrorMessage == null
                    ? SizedBox()
                    : Text(
                        rightChoiceErrorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: LibrinoColors.validationErrorRed,
                          fontSize: 13,
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
                      Text('Questão pública')
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
