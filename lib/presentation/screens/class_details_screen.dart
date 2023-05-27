import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';

import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/logic/cubits/participants/load_participants_cubit.dart';
import 'package:librino/logic/cubits/participants/load_participants_state.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/class_details/participant_item_of_list.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LibrinoColors.backgroundGray,
      appBar: AppBar(
        bottomOpacity: 0,
        elevation: 0,
        backgroundColor: LibrinoColors.deepOrange,
        titleTextStyle: TextStyle(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0, // important
            color: LibrinoColors.deepOrange, // Color of your appbar
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
          PopupMenuButton(
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
                  child: const Text('Tornar turma ativa'),
                ),
              ];
            },
          ),
        ],
      ),
      body: BlocBuilder<LoadParticipantsCubit, LoadParticipantsState>(
        builder: (context, state) => RefreshIndicator(
          onRefresh: () => loadCubit.loadFromClass(widget.clazz.id!),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      color: LibrinoColors.deepOrange,
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
                      padding: const EdgeInsets.fromLTRB(
                        Sizes.defaultScreenHorizontalMargin,
                        24,
                        Sizes.defaultScreenHorizontalMargin,
                        0,
                      ),
                      child: Text(
                        state is LoadingParticipantsState
                            ? 'Carregando participantes...'
                            : '${state is ParticipantsLoadedState ? "${state.participants.length} " : ""} Participantes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: LibrinoColors.textLightBlack),
                      ),
                    ),
                  ],
                ),
              ),
              if (state is LoadingParticipantsState)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.defaultScreenHorizontalMargin,
                    24,
                    Sizes.defaultScreenHorizontalMargin,
                    16,
                  ),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate(List.generate(
                    6,
                    (_) => Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      child: ParticipantItemOfListWidget(isLoading: true),
                    ),
                  ))),
                )
              else if (state is ParticipantsLoadedState &&
                  state.participants.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.defaultScreenHorizontalMargin,
                    24,
                    Sizes.defaultScreenHorizontalMargin,
                    16,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      LayoutBuilder(
                        builder: (_, consts) => IllustrationWidget(
                          illustrationName: 'void.png',
                          title: 'Sem nínguem por aqui',
                          subtitle:
                              'Ainda não há ninguém matriculado na turma. Compartilhe esta turma com outras pessoas.',
                          imageWidth: consts.maxWidth * .5,
                          textImageSpacing: 24,
                          fontSize: 17.5,
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
                    24,
                    Sizes.defaultScreenHorizontalMargin,
                    16,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        child: ParticipantItemOfListWidget(
                          participant: state.participants[index],
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
                    24,
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
                          fontSize: 17.5,
                        ),
                      )
                    ]),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
