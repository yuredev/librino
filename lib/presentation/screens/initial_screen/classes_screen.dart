import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/presentation/widgets/classes/class_widget.dart';
import 'package:librino/presentation/widgets/shared/initial_app_bar.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen();

  final listLength = 9;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                InitialAppBar(
                  conclusionPercentage: 80,
                  compact: true,
                  secondLineText: 'Estas são suas turmas',
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
                    margin: const EdgeInsets.only(bottom: 12, left: 6),
                    child: const Text(
                      'Turma selecionada: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                      ),
                    ),
                  ),
                  ClassWidget(
                    color: LibrinoColors.deepOrange,
                    textColor: Colors.white,
                    disabled: true,
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
                      bottom: 12,
                    ),
                    child: Text(
                      'Outras turmas: ',
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
          SliverPadding(
            padding: const EdgeInsets.only(
              left: Sizes.defaultScreenHorizontalMargin,
              right: Sizes.defaultScreenHorizontalMargin,
              bottom: Sizes.defaultScreenBottomMargin,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: listLength,
                (context, index) => Container(
                  margin: EdgeInsets.only(
                    bottom: index == listLength - 1 ? 0 : 25,
                  ),
                  child: ClassWidget(
                    color: LibrinoColors.backgroundWhite,
                    textColor: LibrinoColors.subtitleGray,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
