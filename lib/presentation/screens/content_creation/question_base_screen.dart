import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/question/question.dart';
import 'package:librino/data/models/question_filter.dart';
import 'package:librino/logic/cubits/question/actions/question_actions_cubit.dart';
import 'package:librino/logic/cubits/question/actions/question_actions_state.dart';
import 'package:librino/logic/cubits/question/load_questions/load_questions_base_cubit.dart';
import 'package:librino/logic/cubits/question/load_questions/load_questions_state.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/question_base/question_filter_modal.dart';
import 'package:librino/presentation/widgets/shared/filter_chip_widget.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:librino/presentation/widgets/shared/list_tile_widget.dart';
import 'package:librino/presentation/widgets/shared/search_bar_widget.dart';

class QuestionBaseScreen extends StatefulWidget {
  const QuestionBaseScreen({super.key});

  @override
  State<QuestionBaseScreen> createState() => _QuestionBaseScreenState();
}

class _QuestionBaseScreenState extends State<QuestionBaseScreen> {
  Question? selectedQuestion;
  final searchBarCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late final LoadQuestionBaseCubit loadCubit = context.read();
  var filter = QuestionFilter();
  final scrollCtrl = ScrollController();
  var showEndLoadingMessage = false;
  var isFetchingMore = false;
  var isSwipeActive = false;
  final questions = <Question>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCubit.load(filter);
    });
  }

  List<Question> getVisibleQuestions(List<Question> questions) {
    var filteredQuestions = questions;

    if (filter.text?.isNotEmpty ?? false) {
      filteredQuestions = filteredQuestions
          .where((element) => element.statement
              .toLowerCase()
              .contains(filter.text!.toLowerCase()))
          .toList();
    }

    if (filter.questionType != null) {
      filteredQuestions = filteredQuestions
          .where((element) => element.type == filter.questionType)
          .toList();
    }

    return filteredQuestions;
  }

  void onSelectQuestion(Question question) async {
    final mustAdd = (await Navigator.pushNamed(context, Routes.previewQuestion,
        arguments: {'question': question})) as bool?;
    if (mustAdd == null) return;
    if (mustAdd && context.mounted) {
      Navigator.pop(context, question);
    }
  }

  Future<void> refreshScreen() async {
    setState(() {
      questions.clear();
      isSwipeActive = true;
    });
    await loadCubit.load(filter);
    setState(() {
      isSwipeActive = false;
    });
  }

  void onLoadListen(BuildContext context, LoadQuestionsState state) {
    if (state is PaginatedQuestionsLoadedState) {
      setState(() {
        questions.clear();
        questions.addAll(state.questions);
      });
    }
  }

  void onQuestionCreated(BuildContext context, QuestionActionsState state) {
    if (state is QuestionCreatedState) {
      Navigator.pop(context);
      Navigator.pop(context, state.question);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LibrinoColors.backgroundGray,
      appBar: AppBar(
        backgroundColor: LibrinoColors.mainDeeper,
        centerTitle: true,
        title: const Text(
          'Banco de questões',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'Criar nova questão',
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, Routes.selectQuestionType);
          },
          label: const Text(
            'Criar',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          icon: const Icon(Icons.add),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshScreen,
        child: BlocConsumer<LoadQuestionBaseCubit, LoadQuestionsState>(
          listener: onLoadListen,
          builder: (context, state) =>
              BlocListener<QuestionActionsCubit, QuestionActionsState>(
            listenWhen: (previous, current) => current is QuestionCreatedState,
            listener: onQuestionCreated,
            child: CustomScrollView(
              controller: scrollCtrl,
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: Sizes.defaultScreenHorizontalMargin,
                    right: Sizes.defaultScreenHorizontalMargin,
                    top: 26,
                    bottom: 26,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          margin: const EdgeInsets.only(bottom: 22),
                          child: const Text(
                            'Questões disponíveis',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.5,
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(bottom: filter.isEmpty ? 16 : 14),
                          child: Row(
                            children: [
                              // TODO:
                              Flexible(
                                child: SearchBarWidget(
                                  formKey: formKey,
                                  hint: 'Pesquisar questão',
                                  controller: searchBarCtrl,
                                  // sendButtonColor: LibrinoColors.iconGray,
                                  onChange: (text) {
                                    setState(() {
                                      filter = filter.copyWith(text: text);
                                    });
                                  },
                                  // onSendButtonPress: () {
                                  //   loadCubit.load(filter);
                                  // },
                                ),
                              ),
                              // TODO:
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: LibrinoColors.backgroundWhite,
                                    borderRadius: BorderRadius.circular(
                                      Sizes.defaultInputBorderRadius,
                                    ),
                                    border: Border.all(
                                      color: LibrinoColors.borderGray,
                                      width: .9,
                                    ),
                                  ),
                                  child: Tooltip(
                                    message: 'Filtrar questões',
                                    child: InkWellWidget(
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        final newFilter =
                                            await PresentationUtils
                                                .showBottomModal<
                                                    QuestionFilter?>(
                                          context,
                                          QuestionFilterModal(
                                            questionFilter: filter,
                                          ),
                                        );
                                        if (newFilter == null) return;
                                        setState(
                                          () => filter = filter.copyWith(
                                            text: newFilter.text,
                                            questionType:
                                                newFilter.questionType,
                                          ),
                                        );
                                      },
                                      borderRadius:
                                          Sizes.defaultInputBorderRadius,
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.tune,
                                          color: LibrinoColors.subtitleGray,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (filter.questionType != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FilterChipWidget(
                                  titulo: questionTypeToString[
                                      filter.questionType]!,
                                  aoPressionarFechar: () {
                                    setState(() {
                                      filter = filter.copyWithout(
                                          questionType: true);
                                    });
                                    PresentationUtils.showToast(
                                      'Filtro removido',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (state is LoadingPaginatedQuestionsState)
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: Sizes.defaultScreenHorizontalMargin,
                      right: Sizes.defaultScreenHorizontalMargin,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        List.generate(
                          7,
                          (index) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTileWidget(
                              isLoading: true,
                              icon: Icons.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else if (state is PaginatedQuestionsLoadedState)
                  Builder(
                    builder: (context) {
                      final questions = getVisibleQuestions(state.questions);
                      return questions.isEmpty
                          ? SliverPadding(
                              padding: const EdgeInsets.only(
                                left: Sizes.defaultScreenHorizontalMargin,
                                right: Sizes.defaultScreenHorizontalMargin,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    IllustrationWidget(
                                      illustrationName: 'no-data.png',
                                      title: filter.isEmpty
                                          ? 'Sem questões cadastradas'
                                          : 'Sem resultados',
                                      subtitle: filter.isEmpty
                                          ? 'No momento não há questões cadastradas no banco de questões do Librino'
                                          : 'Não há questões que condizem com os filtros selecionados',
                                      imageWidth:
                                          MediaQuery.of(context).size.width *
                                              0.41,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.only(
                                left: Sizes.defaultScreenHorizontalMargin,
                                right: Sizes.defaultScreenHorizontalMargin,
                                bottom:
                                    Sizes.defaultScreenBottomMargin * 2 + 12,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final q = questions[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: ListTileWidget(
                                        title: q.label,
                                        subtitle: questionTypeToString[q.type],
                                        onTap: () => onSelectQuestion(q),
                                        icon: Icons.sign_language_outlined,
                                      ),
                                    );
                                  },
                                  childCount: questions.length,
                                ),
                              ),
                            );
                    },
                  )
                else if (state is LoadQuestionsErrorState)
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: Sizes.defaultScreenHorizontalMargin,
                      right: Sizes.defaultScreenHorizontalMargin,
                      top: 26,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          IllustrationWidget(
                            illustrationName: 'error.json',
                            isAnimation: true,
                            title: state.errorMessage,
                            imageWidth:
                                MediaQuery.of(context).size.width * 0.45,
                            textImageSpacing: 0,
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
