import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';

import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/logic/cubits/class/select/select_class_state.dart';
import 'package:librino/logic/cubits/participants/load_participants_cubit.dart';
import 'package:librino/logic/cubits/participants/load_participants_state.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_cubit.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_state.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/class_details/participant_item_of_list.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';
import 'package:librino/presentation/widgets/shared/shimmer_widget.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:share_plus/share_plus.dart';

class ClassDetailsScreen extends StatefulWidget {
  final Class clazz;

  const ClassDetailsScreen({
    Key? key,
    required this.clazz,
  }) : super(key: key);

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  late final LoadParticipantsCubit loadCubit = Bindings.get();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCubit.loadFromClass(widget.clazz.id!);
    });
  }

  void onShareClassPress() {
    Share.share(
      'Copie e cole o código ${widget.clazz.id} para entrar na turma ${widget.clazz.name} do Librino',
    );
  }

  void onCopyToClipboardPress() {
    Clipboard.setData(ClipboardData(text: widget.clazz.id)).then(
      (value) => PresentationUtils.showSnackBar(
        context,
        'Código da turma copiado para a área de transferência',
      ),
    );
  }

  void onSelectClassPress() {
    context.read<SelectClassCubit>().select(widget.clazz);
  }

  Widget buildPopupButtons({Widget? child}) {
    return PopupMenuButton(
      child: child,
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            onTap: onCopyToClipboardPress,
            child: const Text('Copiar código'),
          ),
          PopupMenuItem<int>(
            value: 1,
            onTap: onShareClassPress,
            child: const Text('Compartilhar'),
          ),
          PopupMenuItem<int>(
            value: 2,
            onTap: onSelectClassPress,
            child: const Text('Tornar turma ativa'),
          ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LibrinoColors.backgroundGray,
      appBar: AppBar(
        bottomOpacity: 0,
        elevation: 0,
        backgroundColor: LibrinoColors.mainDeeper,
        titleTextStyle: TextStyle(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0, // important
            color: LibrinoColors.mainDeeper, // Color of your appbar
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.clazz.name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          MultiBlocListener(
            listeners: [
              BlocListener<SelectClassCubit, SelectClassState>(
                listener: (_, state) {
                  PresentationUtils.showToast(
                    '${widget.clazz.name} selecionada!',
                  );
                },
              ),
              BlocListener<SubscriptionActionsCubit, SubscriptionActionsState>(
                listenWhen: (previous, current) {
                  if (previous is RepprovingSubscriptionState) {
                    Navigator.pop(context); // locked loading
                  }
                  return [
                    RepprovingSubscriptionState,
                    SubscriptionRepprovedState,
                    RepproveSubscriptionError,
                  ].contains(current.runtimeType);
                },
                listener: (_, state) {
                  if (state is RepprovingSubscriptionState) {
                    PresentationUtils.showLockedLoading(
                      context,
                      text: 'Removendo participante...',
                    );
                  } else if (state is SubscriptionRepprovedState) {
                    loadCubit.loadFromClass(widget.clazz.id!);
                  }
                },
              ),
            ],
            child: buildPopupButtons(),
          ),
        ],
      ),
      body: BlocBuilder<LoadParticipantsCubit, LoadParticipantsState>(
        builder: (context, state) {
          final dataMap = {
            'Ouvintes': state is ParticipantsLoadedState
                ? state.participants
                    .where((e) => e.auditoryAbility == AuditoryAbility.hearer)
                    .length
                    .toDouble()
                : 3.0,
            'Surdos': state is ParticipantsLoadedState
                ? state.participants
                    .where((e) => e.auditoryAbility == AuditoryAbility.deaf)
                    .length
                    .toDouble()
                : 7.0,
          };
          final auditoryAbilityChart = PieChart(
            dataMap: dataMap,
            animationDuration: Duration(
              milliseconds: state is LoadingParticipantsState ? 0 : 800,
            ),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 3.5,
            colorList: [
              LibrinoColors.main,
              Colors.red,
            ],
            initialAngleInDegree: 0,
            ringStrokeWidth: 32,
            legendOptions: LegendOptions(
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: ChartValuesOptions(
              decimalPlaces: 0,
            ),
          );
          return RefreshIndicator(
            onRefresh: () => loadCubit.loadFromClass(widget.clazz.id!),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        color: LibrinoColors.mainDeeper,
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.defaultScreenHorizontalMargin,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                'Descrição',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              widget.clazz.description,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: Sizes.defaultScreenHorizontalMargin,
                          right: Sizes.defaultScreenHorizontalMargin,
                          top: 24,
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: RichText(
                            text: TextSpan(
                              text: 'Instrutor: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: LibrinoColors.textLightBlack,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.clazz.ownerName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: LibrinoColors.subtitleGray,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is LoadingParticipantsState ||
                    state is ParticipantsLoadedState &&
                        state.participants.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      Sizes.defaultScreenHorizontalMargin,
                      0,
                      Sizes.defaultScreenHorizontalMargin,
                      16,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          ExpansionTile(
                            initiallyExpanded: true,
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: Text(
                              'Estatísticas',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: LibrinoColors.textLightBlack,
                              ),
                            ),
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: state is LoadingParticipantsState
                                    ? ShimmerWidget(child: auditoryAbilityChart)
                                    : auditoryAbilityChart,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                if (state is LoadingParticipantsState)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      Sizes.defaultScreenHorizontalMargin,
                      8,
                      Sizes.defaultScreenHorizontalMargin,
                      16,
                    ),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate(List.generate(
                      6,
                      (_) => Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        child: ParticipantItemOfListWidget(
                          classId: widget.clazz.id!,
                          isLoading: true,
                        ),
                      ),
                    ))),
                  )
                else if (state is ParticipantsLoadedState &&
                    state.participants.isEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      Sizes.defaultScreenHorizontalMargin,
                      8,
                      Sizes.defaultScreenHorizontalMargin,
                      16,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        LayoutBuilder(
                          builder: (_, consts) => Column(
                            children: [
                              IllustrationWidget(
                                illustrationName: 'void.png',
                                title: 'Sem nínguem por aqui',
                                subtitle:
                                    'Ainda não há ninguém matriculado na turma. Compartilhe esta turma com outras pessoas.',
                                imageWidth: consts.maxWidth * .5,
                                textImageSpacing: 24,
                                fontSize: 17.5,
                              ),
                              buildPopupButtons(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Compartilhar Turma',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: LibrinoColors.mainDeeper,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  )
                else if (state is ParticipantsLoadedState &&
                    state.participants.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      Sizes.defaultScreenHorizontalMargin,
                      8,
                      Sizes.defaultScreenHorizontalMargin,
                      16,
                    ),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                      Text(
                        state is LoadingParticipantsState
                            ? 'Carregando participantes...'
                            : '${state.participants.length} Participantes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: LibrinoColors.textLightBlack,
                        ),
                      ),
                    ])),
                  ),
                if (state is ParticipantsLoadedState &&
                    state.participants.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      Sizes.defaultScreenHorizontalMargin,
                      8,
                      Sizes.defaultScreenHorizontalMargin,
                      16,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          child: ParticipantItemOfListWidget(
                            classId: widget.clazz.id!,
                            participant: state.participants[index],
                            onPress: () {
                              Navigator.pushNamed(
                                context,
                                Routes.profile,
                                arguments: {
                                  'user': state.participants[index],
                                  'class': widget.clazz,
                                },
                              );
                            },
                          ),
                        ),
                        childCount: state.participants.length,
                      ),
                    ),
                  )
                else if (state is LoadParticipantsErrorState)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      Sizes.defaultScreenHorizontalMargin,
                      8,
                      Sizes.defaultScreenHorizontalMargin,
                      16,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        LayoutBuilder(
                          builder: (_, consts) => IllustrationWidget(
                            illustrationName: 'error.json',
                            isAnimation: true,
                            title: state.message,
                            imageWidth: consts.maxWidth * .63,
                            textImageSpacing: 10,
                            fontSize: 15,
                          ),
                        )
                      ]),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
