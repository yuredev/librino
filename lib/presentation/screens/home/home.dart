import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/class/load/load_classes_cubit.dart';
import 'package:librino/logic/cubits/class/load_default/load_default_class_cubit.dart';
import 'package:librino/logic/cubits/class/load_default/load_default_class_state.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/logic/cubits/class/select/select_class_state.dart';
import 'package:librino/logic/cubits/module/load/load_modules_cubit.dart';
import 'package:librino/logic/cubits/subscription/load/load_subscriptions_cubit.dart';
import 'package:librino/presentation/screens/home/classes_screen.dart';
import 'package:librino/presentation/screens/home/learning_overview_screen.dart';
import 'package:librino/presentation/screens/home/subscription_requests_screen.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/learning_overview/librino_drawer.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';

const defaultClass = 'ZuNAujmyuUYeRfJdJKdi';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final LoadModulesCubit loadModulesCubit = context.read();
  late final LoadClassesCubit loadClassesCubit = context.read();
  late final SelectClassCubit selectClassCubit = context.read();
  late final LoadDefaultClassCubit loadDefaultClassCubit = context.read();
  late final LoadSubscriptionsCubit loadSubscriptionsCubit = context.read();

  late final List<Widget> tabs;
  var activeTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDefaultClassCubit.load();
      loadModulesCubit.loadFromClass(defaultClass);
      loadClassesCubit.load();
      loadSubscriptionsCubit.load();
    });
    tabs = [
      LearningOverviewScreen(
        listCubit: loadModulesCubit,
        switchTabCallback: () => setState(
          () => activeTab = 1,
        ),
      ),
      ClassesScreen(
        switchTabCallback: () => setState(
          () => activeTab = 0,
        ),
      ),
      SubscriptionRequestsScreen(),
    ];
  }

  void onAuthListen(BuildContext context, AuthState state) {
    if (state is LoggedOutState) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  void onLoadDefaultClassListen(
      BuildContext context, LoadDefaultClassState state) {
    if (state is DefaultClassLoadedState) {
      selectClassCubit.select(state.clazz);
    } else if (state is ErrorAtLoadDefaultClassState) {
      // TODO: fazer algo caso não seja possível encontrar a turma padrão?
    }
  }

  @override
  Widget build(BuildContext context) {
    const iconsSize = 30.0;
    return LibrinoScaffold(
      backgroundColor: LibrinoColors.backgroundGray,
      floatingActionButton: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (_, state) => state is LoggedInState,
        builder: (context, state) {
          final user = (state as LoggedInState).user;
          if (activeTab == 1) {
            return user.isInstructor
                ? FloatingActionButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.createClass),
                    child: Tooltip(
                      message: 'Adicionar turma',
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  )
                : FloatingActionButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.searchClass),
                    child: Tooltip(
                      message: 'Procurar turma',
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  );
          } else if (activeTab == 0) {
            return user.profileType == ProfileType.instructor
                ? BlocBuilder<SelectClassCubit, SelectClassState>(
                    builder: (context, state) => FloatingActionButton.extended(
                      onPressed: () {
                        if (state.clazz == null) {
                          PresentationUtils.showSnackBar(
                            context,
                            'Nenhuma turma selecionada!',
                            isErrorMessage: true,
                          );
                          return;
                        }
                        Navigator.pushNamed(
                          context,
                          Routes.createModule,
                          arguments: {'class': state.clazz},
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: Tooltip(
                        message: 'Criar conteúdo para a turma',
                        child: const Text(
                          'Criar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox();
          }
          return SizedBox();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeTab,
        onTap: (index) {
          setState(() => activeTab = index);
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, size: iconsSize),
            label: 'Aprendizado',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.groups, size: iconsSize),
            label: 'Turmas',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active, size: iconsSize),
            label: 'Solicitações',
          ),
        ],
      ),
      rightDrawer: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) => current is LoggedInState,
        builder: (context, state) => LibrinoDrawer(
          user: (state as LoggedInState).user,
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) => current is LoggedInState,
        builder: (previous, authState) => MultiBlocListener(
          listeners: [
            BlocListener<AuthCubit, AuthState>(
              listenWhen: (previous, current) => current is LoggedOutState,
              listener: onAuthListen,
              child: tabs[activeTab],
            ),
            BlocListener<LoadDefaultClassCubit, LoadDefaultClassState>(
              listenWhen: (_, state) =>
                  selectClassCubit.state.clazz == null &&
                  (authState as LoggedInState).user.profileType ==
                      ProfileType.studant,
              listener: onLoadDefaultClassListen,
              child: tabs[activeTab],
            ),
          ],
          child: tabs[activeTab],
        ),
      ),
    );
  }
}
