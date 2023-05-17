import 'package:flutter/material.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/user/librino_user.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InitialAppBar(
            conclusionPercentage: 80,
            user: LibrinoUser(
              auditoryAbility: AuditoryAbility.deaf,
              email: 'yurematias26@gmail.com',
              id: 'SJGFSIJ935FJ',
              name: 'Yure',
              surname: 'Matias',
              profileType: ProfileType.studant,
              genderIdentity: GenderIdentity.man,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Sizes.defaultScreenHorizontalMargin,
              30,
              Sizes.defaultScreenHorizontalMargin,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 22, left: 6),
                  child: Text(
                    'Seu aprendizado',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                    ),
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
      ),
    );
  }
}
