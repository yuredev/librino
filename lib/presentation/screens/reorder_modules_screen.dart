// ignore_for_file: use_build_context_synchronously

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_cubit.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_state.dart';
import 'package:librino/logic/cubits/module/load/load_modules_cubit.dart';
import 'package:librino/logic/cubits/module/load/load_modules_state.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:reorderables/reorderables.dart';

class ReorderModulesScreen extends StatefulWidget {
  const ReorderModulesScreen({super.key});

  @override
  State<ReorderModulesScreen> createState() => _ReorderModulesScreenState();
}

class _ReorderModulesScreenState extends State<ReorderModulesScreen> {
  late final ModuleActionsCubit moduleActionsCubit = context.read();
  final List<Module> modules = [];

  @override
  void initState() {
    context.read<LoadModulesCubit>().load();
    super.initState();
  }

  void onListen(BuildContext context, LoadModulesState state) {
    if (state is HomeModulesListLoaded) {
      modules
        ..clear()
        ..addAll(state.modules);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Tooltip(
        message: 'Salvar',
        child: FloatingActionButton(
          onPressed: () async {
            PresentationUtils.showLockedLoading(context, text: 'Salvando...');
            await moduleActionsCubit.reorder(modules);
            Navigator.pop(context);
          },
          child: const Icon(Icons.save),
        ),
      ),
      appBar: AppBar(
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Ordenar Módulos',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocConsumer<LoadModulesCubit, LoadModulesState>(
        listener: onListen,
        builder: (context, state) {
          if (state is! HomeModulesListLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Lottie.asset('assets/animations/searching-class.json'),
                  ),
                  Text('Carregando...'),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: Sizes.defaultScreenTopMargin,
              bottom: Sizes.defaultScreenBottomMargin * 4,
              left: Sizes.defaultScreenHorizontalMargin,
              right: Sizes.defaultScreenHorizontalMargin,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocListener<ModuleActionsCubit, ModuleActionsState>(
                  listener: (context, state) {
                    if (state is ModulesOrderUpdatedState) {
                      Navigator.pop(context);
                    }
                  },
                  child: SizedBox(),
                ),
                ReorderableWrap(
                  needsLongPressDraggable: false,
                  spacing: 16,
                  runSpacing: 16,
                  onReorder: (oldIndex, newIndex) {
                    final aux = modules[oldIndex];
                    setState(() {
                      modules[oldIndex] = modules[newIndex];
                      modules[newIndex] = aux;
                      modules[oldIndex] =
                          modules[oldIndex].copyWith(index: oldIndex);
                      modules[newIndex] =
                          modules[newIndex].copyWith(index: newIndex);
                    });
                  },
                  children: modules.asMap().entries.map(
                    (entry) {
                      final m = entry.value;
                      final i = entry.key;
                      return Stack(
                        children: [
                          DottedBorder(
                            color: LibrinoColors.borderGray,
                            strokeWidth: 1.2,
                            dashPattern: [2.5, 2],
                            radius: Radius.circular(20),
                            borderType: BorderType.RRect,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: LibrinoColors.backgroundWhite,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.03),
                                    spreadRadius: 1.25,
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  m.imageUrl == null
                                      ? Image.asset(
                                          'assets/images/generic-module.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          m.imageUrl!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/generic-module.png',
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.contain,
                                            );
                                          },
                                        ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 120,
                                    margin: const EdgeInsets.only(top: 16),
                                    child: FittedBox(
                                      child: Text(
                                        m.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
