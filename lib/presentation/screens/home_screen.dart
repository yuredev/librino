import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/user.dart';
import 'package:librino/logic/cubits/module/home_modules_list/home_modules_list_cubit.dart';
import 'package:librino/presentation/widgets/home/home_app_bar.dart';
import 'package:librino/presentation/widgets/home/home_modules_grid_widget.dart';
import 'package:librino/presentation/widgets/home/librino_drawer.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:librino/presentation/widgets/shared/refreshable_scrollview_widget.dart';

const defaultClass = 'ZuNAujmyuUYeRfJdJKdi';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  late final listCubit = context.read<HomeModulesListCubit>();
  late final List<Widget> tabs;
  var activeTab = 0;

  @override
  void initState() {
    listCubit.loadFromClass(defaultClass);
    tabs = [
      _LearningOverview(listCubit: listCubit),
      _ClassesWidget(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const iconsSize = 30.0;
    return LibrinoScaffold(
      backgroundColor: LibrinoColors.backgroundGray,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeTab,
        onTap: (index) {
          if (index == 2) {
            return;
          }
          setState(() => activeTab = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home_outlined,
              size: iconsSize,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.leaderboard,
              size: iconsSize,
            ),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.groups,
              size: iconsSize,
            ),
            label: 'Turmas',
          ),
        ],
      ),
      rightDrawer: LibrinoDrawer(
        user: User(
          name: 'Yure Matias',
          email: 'yurematiias26@gmail.com',
        ),
      ),
      body: tabs[activeTab],
    );
  }
}

class _LearningOverview extends StatefulWidget {
  final HomeModulesListCubit listCubit;

  const _LearningOverview({
    required this.listCubit,
  });

  @override
  State<_LearningOverview> createState() => _LearningOverviewState();
}

class _LearningOverviewState extends State<_LearningOverview> {
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
          HomeAppBar(
            conclusionPercentage: 80,
            user: User(
              name: 'Yure Matias',
              email: 'yurematias26@gmail.com',
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
                  child: HomeModulesGridWidget(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ClassesWidget extends StatelessWidget {
  const _ClassesWidget();

  @override
  Widget build(BuildContext context) {
    return LibrinoScaffold(
      body: RefreshableScrollViewWidget(
        onRefresh: () async {},
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
