import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/modal_top_bar_widget.dart';

class SelectClassModal extends StatelessWidget {
  const SelectClassModal({super.key});

  @override
  Widget build(BuildContext context) {
    const topBarSpacing = 17.0;
    return Container(
      padding: EdgeInsets.symmetric(vertical: topBarSpacing, horizontal: 24),
      height: MediaQuery.of(context).size.height * .55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: topBarSpacing,
              ),
              child: ModalTopBarWidgetWidget(),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 24,
              ),
              child: Text(
                'Turma LIBRAS A3853-JADIF',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 24,
            ),
            child: RichText(
              text: TextSpan(
                text: 'Professor: ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Fulano da Silva',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'N° de participantes: ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: '21',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.only(
              bottom: 16,
            ),
            child: ButtonWidget(
              title: 'Ver turma',
              width: double.infinity,
              height: Sizes.defaultButtonHeight,
              onPress: () {
                Navigator.pushNamed(
                  context,
                  Routes.classDetails,
                  arguments: {
                    'class': Class(
                      description:
                          'lorem ipsilum dolor conseq asag mmvndj iw3iwwr aso da tas vasfj',
                      id: '343446439JAJJFA44t-0-0VSKOKOSF_k34k035556[]~;;s',
                      name: 'A3853-JADIF',
                    )
                  },
                );
              },
              color: LibrinoColors.buttonGray,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 13,
            ),
            child: ButtonWidget(
              title: 'Tornar turma ativa',
              width: double.infinity,
              height: Sizes.defaultButtonHeight,
              onPress: () {},
            ),
          )
        ],
      ),
    );
  }
}
