import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/module/load_modules_cubit.dart';
import 'package:librino/presentation/widgets/shared/initial_app_bar.dart';
import 'package:librino/presentation/widgets/learning_overview/modules_grid_widget.dart';
import 'package:librino/presentation/widgets/shared/refreshable_scrollview_widget.dart';

const defaultClass = 'ZuNAujmyuUYeRfJdJKdi';

class LearningOverviewScreen extends StatefulWidget {
  final LoadModulesCubit listCubit;

  const LearningOverviewScreen({
    required this.listCubit,
  });

  @override
  State<LearningOverviewScreen> createState() => _LearningOverviewScreenState();
}

class _LearningOverviewScreenState extends State<LearningOverviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshableScrollViewWidget(
      onRefresh: () async => widget.listCubit.loadFromClass(defaultClass),
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
                firstLineText: 'Olá ${user.name}',
                secondLineText: user.profileType == ProfileType.studant
                    ? 'Continue aprendendo!'
                    : 'Continue criando!',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Sizes.defaultScreenHorizontalMargin,
                  20,
                  Sizes.defaultScreenHorizontalMargin,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TODO: mudar texto
                    Container(
                      margin: const EdgeInsets.only(bottom: 18, left: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              user.profileType == ProfileType.studant
                                  ? 'Seu aprendizado'
                                  : 'Conteúdo da turma: X',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                'Mudar turma',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: Sizes.defaultScreenBottomMargin,
                      ),
                      child: ModulesGridWidget(),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
