import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/logic/cubits/module/load_modules_cubit.dart';
import 'package:librino/presentation/screens/initial_screen/classes_screen.dart';
import 'package:librino/presentation/screens/initial_screen/learning_overview_screen.dart';
import 'package:librino/presentation/widgets/learning_overview/librino_drawer.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';

const defaultClass = 'ZuNAujmyuUYeRfJdJKdi';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  late final listCubit = context.read<LoadModulesCubit>();
  late final List<Widget> tabs;
  var activeTab = 0;

  @override
  void initState() {
    listCubit.loadFromClass(defaultClass);
    tabs = [
      LearningOverviewScreen(listCubit: listCubit),
      // RankingScreen(),
      ClassesScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const iconsSize = 30.0;
    return LibrinoScaffold(
      backgroundColor: LibrinoColors.backgroundGray,
      floatingActionButton: activeTab == 2
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: LibrinoColors.deepOrange,
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeTab,
        onTap: (index) {
          setState(() => activeTab = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.menu_book,
              size: iconsSize,
            ),
            label: 'Aprendizado',
          ),
          // BottomNavigationBarItem(
          //   icon: const Icon(
          //     Icons.leaderboard,
          //     size: iconsSize,
          //   ),
          //   label: 'Ranking',
          // ),
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
      body: tabs[activeTab],
    );
  }
}
