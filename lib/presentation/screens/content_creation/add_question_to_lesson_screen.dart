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
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:librino/presentation/widgets/shared/list_tile_widget.dart';
import 'package:librino/presentation/widgets/shared/search_bar_widget.dart';

class AddQuestionToLessonScreen extends StatefulWidget {
  const AddQuestionToLessonScreen({super.key});

  @override
  State<AddQuestionToLessonScreen> createState() =>
      _AddQuestionToLessonScreenState();
}

class _AddQuestionToLessonScreenState extends State<AddQuestionToLessonScreen> {
  Question? selectedQuestion;
  final searchBarCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late final LoadQuestionBaseCubit loadCubit = context.read();
  var filter = QuestionFilter();
  final scrollCtrl = ScrollController();
  var page = 0;
  var showEndLoadingMessage = false;
  var isFetchingMore = false;
  var isSwipeActive = false;
  var allWasLoaded = false;
  final questions = <Question>[];
  static const _paginationSize = 20;

  Question? get lastQuestion =>
      questions.isEmpty ? null : questions[page * (_paginationSize - 1)];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCubit.load(filter, lastQuestion, page);
    });
    scrollCtrl.addListener(() {});
  }

  void onScrollListen() async {
    final chegouFinalTela = scrollCtrl.position.pixels >=
        (scrollCtrl.position.maxScrollExtent * 0.8);
    setState(() {
      showEndLoadingMessage = chegouFinalTela;
    });
    if (!allWasLoaded && !isSwipeActive && chegouFinalTela && !isFetchingMore) {
      setState(() {
        page++;
        isFetchingMore = true;
      });
      await loadCubit.load(filter, lastQuestion, page);
      setState(() => isFetchingMore = false);
    }
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
      page = 0;
      isSwipeActive = true;
      allWasLoaded = false;
    });
    await loadCubit.load(filter, lastQuestion, page);
    setState(() {
      isSwipeActive = false;
    });
  }

  void onLoadListen(BuildContext context, LoadQuestionsState state) {
    if (state is PaginatedQuestionsLoadedState) {
      setState(() {
        if (state.page == 0) {
          questions.clear();
          page = 0;
          allWasLoaded = false;
        }
        if (state.questions.isEmpty) {
          allWasLoaded = true;
        } else {
          questions.addAll(state.questions);
        }
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
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Nova Lição - Adicionar Questão',
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
          label: const Text('Criar',
              style: TextStyle(fontWeight: FontWeight.bold)),
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
                            'Banco de questões',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.5,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 36),
                          child: Row(
                            children: [
                              Flexible(
                                child: SearchBarWidget(
                                  formKey: formKey,
                                  hint: 'Pesquisar questão',
                                  controller: searchBarCtrl,
                                  sendButtonColor: LibrinoColors.iconGray,
                                  onChange: (text) {
                                    setState(() {
                                      filter = filter.copyWith(text: text);
                                    });
                                  },
                                  onSendButtonPress: () {
                                    if (searchBarCtrl.text.trim().isNotEmpty) {
                                      loadCubit.load(
                                          filter, lastQuestion, page);
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: LibrinoColors.lightGrayDarker,
                                    borderRadius: BorderRadius.circular(
                                      Sizes.defaultInputBorderRadius,
                                    ),
                                  ),
                                  child: Tooltip(
                                    message: 'Filtrar questões',
                                    child: InkWellWidget(
                                      onTap: () {},
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
                      ],
                    ),
                  ),
                ),
                if (state is LoadingPaginatedQuestionsState && state.page == 0)
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
                else if (state is PaginatedQuestionsLoadedState &&
                    state.questions.isEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: Sizes.defaultScreenHorizontalMargin,
                      right: Sizes.defaultScreenHorizontalMargin,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          IllustrationWidget(
                            illustrationName: 'no-data.png',
                            title: 'Sem questões cadastradas',
                            subtitle:
                                'No momento não há questões cadastradas no banco de questões do Librino',
                            imageWidth: MediaQuery.of(context).size.width * 0.41,
                          )
                        ],
                      ),
                    ),
                  )
                else if (state is PaginatedQuestionsLoadedState &&
                    state.questions.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: Sizes.defaultScreenHorizontalMargin,
                      right: Sizes.defaultScreenHorizontalMargin,
                      bottom: Sizes.defaultScreenBottomMargin * 2 + 12,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final q = state.questions[index];
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
                        childCount: state.questions.length,
                      ),
                    ),
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
