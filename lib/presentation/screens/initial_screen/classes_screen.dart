import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/class/load/load_classes_cubit.dart';
import 'package:librino/logic/cubits/class/load/load_classes_state.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/logic/cubits/class/select/select_class_state.dart';
import 'package:librino/presentation/widgets/classes/class_widget.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';
import 'package:librino/presentation/widgets/shared/initial_app_bar.dart';

class ClassesScreen extends StatelessWidget {
  final void Function() switchTabCallback;

  const ClassesScreen({super.key, required this.switchTabCallback});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<LoadClassesCubit>().load,
      child: BlocBuilder<LoadClassesCubit, LoadClassesState>(
        builder: (context, state) => CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final user = (state as LoggedInState).user;
                      return InitialAppBar(
                        conclusionPercentage: 80,
                        compact: true,
                        user: user,
                        firstLineText: 'Olá ${user.name}',
                        secondLineText: 'Estas são suas turmas',
                      );
                    },
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: Sizes.defaultScreenHorizontalMargin,
                right: Sizes.defaultScreenHorizontalMargin,
                top: 26,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      margin: const EdgeInsets.only(bottom: 16, left: 6),
                      child: const Text(
                        'Turma selecionada: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                        ),
                      ),
                    ),
                    BlocBuilder<SelectClassCubit, SelectClassState>(
                      builder: (context, state) => state.clazz == null
                          ? Container(
                              padding: const EdgeInsets.only(
                                left: 12,
                                top: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Icon(
                                      Icons.group_off,
                                      color:
                                          LibrinoColors.iconGray.withOpacity(0.5),
                                      size: 30,
                                    ),
                                  ),
                                  const Text(
                                    'Nenhuma Turma Selecionada',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: LibrinoColors.subtitleDarkGray,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : ClassWidget(
                              color: LibrinoColors.deepOrange,
                              textColor: Colors.white,
                              disabled: true,
                              switchTabCallback: () {},
                              clazz: state.clazz,
                              iconColor: Colors.white.withOpacity(0.7),
                            ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: Divider(
                        thickness: 2.25,
                        height: 2.25,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 24,
                        left: 6,
                        bottom: 24,
                      ),
                      child: Text(
                        'Demais turmas: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state is LoadingClassesState)
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: Sizes.defaultScreenHorizontalMargin,
                  right: Sizes.defaultScreenHorizontalMargin,
                  bottom: Sizes.defaultScreenBottomMargin,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    List.generate(
                      5,
                      (index) => Container(
                        margin: EdgeInsets.only(
                          bottom: index == 5 - 1 ? 0 : 25,
                        ),
                        child: ClassWidget(
                          isLoading: true,
                          color: LibrinoColors.backgroundWhite,
                          textColor: LibrinoColors.subtitleGray,
                          switchTabCallback: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else if (state is ClassesLoadedState && state.classes.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.only(
                    left: Sizes.defaultScreenHorizontalMargin,
                    right: Sizes.defaultScreenHorizontalMargin,
                    bottom: Sizes.defaultScreenBottomMargin,
                    top: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    BlocBuilder<AuthCubit, AuthState>(
                      buildWhen: (_, current) => current is LoggedInState,
                      builder: (context, state) => IllustrationWidget(
                        illustrationName: 'no-data.png',
                        title: 'Sem resultados',
                        subtitle: (state as LoggedInState).user.isInstructor
                            ? 'Você não possui mais turmas'
                            : 'Você não está matriculado em outras turmas',
                        imageWidth: MediaQuery.of(context).size.width * .4,
                      ),
                    )
                  ]),
                ),
              )
            else if (state is ClassesLoadedState && state.classes.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: Sizes.defaultScreenHorizontalMargin,
                  right: Sizes.defaultScreenHorizontalMargin,
                  bottom: Sizes.defaultScreenBottomMargin,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: state.classes.length,
                    (context, index) => Container(
                      margin: EdgeInsets.only(
                        bottom: index == state.classes.length - 1 ? 0 : 25,
                      ),
                      child: ClassWidget(
                        clazz: state.classes[index],
                        color: LibrinoColors.backgroundWhite,
                        textColor: LibrinoColors.subtitleGray,
                        switchTabCallback: switchTabCallback,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
