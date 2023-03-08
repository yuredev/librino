import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/logic/cubits/module/home_modules_list/home_modules_list_cubit.dart';
import 'package:librino/logic/cubits/module/home_modules_list/home_modules_list_state.dart';
import 'package:librino/presentation/screens/loading_screen.dart';
import 'package:librino/presentation/widgets/home/module_grid_item_widget.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';

class HomeModulesGridWidget extends StatelessWidget {
  const HomeModulesGridWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, consts) {
        return BlocBuilder<HomeModulesListCubit, HomeModulesListState>(
          builder: (context, state) {
            if (state is HomeModulesListLoaded) {
              return state.modules.isEmpty
                  ? IllustrationWidget(
                      illustrationName: 'no-data.png',
                      title: 'Sem resultados',
                      subtitle:
                          'Parece que não há conteúdo na turma selecionada',
                      imageWidth: consts.maxWidth * 0.7,
                    )
                  : GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 22,
                      children: state.modules
                          .map(
                            (m) => ModuleGridItemWidget(
                              onPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        LoadingScreen(moduleId: m.id),
                                  ),
                                );
                              },
                              title: m.title,
                              // TODO:
                              conclusionPercentage: 65,
                              imageUrl: m.imageUrl,
                            ),
                          )
                          .toList(),
                    );
            }
            if (state is HomeModulesListError) {
              return IllustrationWidget(
                illustrationName: 'no-internet.json',
                isAnimation: true,
                title: state.message,
                imageWidth: consts.maxWidth * 0.49,
                textImageSpacing: 0,
              );
            }
            return GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 22,
              children: List.generate(
                6,
                (index) => ModuleGridItemWidget(
                  isLoading: true,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
