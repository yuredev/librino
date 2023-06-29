import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/logic/cubits/class/select/select_class_state.dart';
import 'package:librino/logic/cubits/module/load/load_modules_cubit.dart';
import 'package:librino/logic/cubits/module/load/load_modules_state.dart';
import 'package:librino/presentation/widgets/shared/initial_app_bar.dart';
import 'package:librino/presentation/widgets/learning_overview/modules_grid_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:librino/presentation/widgets/shared/refreshable_scrollview_widget.dart';

const defaultClass = 'ZuNAujmyuUYeRfJdJKdi';

class LearningOverviewScreen extends StatefulWidget {
  final void Function() switchTabCallback;
  final LoadModulesCubit listCubit;

  const LearningOverviewScreen({
    required this.listCubit,
    required this.switchTabCallback,
  });

  @override
  State<LearningOverviewScreen> createState() => _LearningOverviewScreenState();
}

class _LearningOverviewScreenState extends State<LearningOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshableScrollViewWidget(
      onRefresh: () async {
        return widget.listCubit.load();
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (_, state) => state is LoggedInState,
        builder: (context, state) {
          final user = (state as LoggedInState).user;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InitialAppBar(
                conclusionPercentage: 80,
                user: user,
                firstLineText: 'Olá ${user.name},',
                secondLineText: user.profileType == ProfileType.studant
                    ? 'Continue aprendendo!'
                    : 'Continue criando!',
              ),
              BlocBuilder<LoadModulesCubit, LoadModulesState>(
                builder: (context, loadModState) => Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.defaultScreenHorizontalMargin,
                    20,
                    Sizes.defaultScreenHorizontalMargin,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20, left: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<SelectClassCubit, SelectClassState>(
                              builder: (context, state) => Flexible(
                                child: Text(
                                  state.clazz?.name ??
                                      'Nenhuma turma selecionada',
                                  style: TextStyle(
                                    fontWeight: state.clazz == null
                                        ? null
                                        : FontWeight.bold,
                                    fontSize: 13.5,
                                    color: state.clazz == null
                                        ? LibrinoColors.subtitleGray
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Tooltip(
                                  message: 'Mudar turma',
                                  child: InkWellWidget(
                                    borderRadius: 2.5,
                                    onTap: widget.switchTabCallback,
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.5),
                                      child: Icon(
                                        Icons.groups_2_outlined,
                                        color: LibrinoColors.iconGray,
                                        size: 23,
                                      ),
                                    ),
                                  ),
                                ),
                                if (user.isInstructor &&
                                    (loadModState is HomeModulesListLoaded ||
                                        loadModState is LoadingHomeModulesList))
                                  SizedBox(width: 10),
                                if (user.isInstructor &&
                                    (loadModState is HomeModulesListLoaded ||
                                        loadModState is LoadingHomeModulesList))
                                  Tooltip(
                                    message: 'Reordenar',
                                    child: InkWellWidget(
                                      borderRadius: 2.5,
                                      onTap:
                                          loadModState is HomeModulesListLoaded
                                              ? () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    Routes.reorderModules,
                                                    arguments: {
                                                      'modules':
                                                          loadModState.modules
                                                    },
                                                  );
                                                }
                                              : null,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.5),
                                        child: Icon(
                                          Icons.toc,
                                          color: LibrinoColors.iconGray,
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: Sizes.defaultScreenBottomMargin * 3,
                        ),
                        child: ModulesGridWidget(),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
