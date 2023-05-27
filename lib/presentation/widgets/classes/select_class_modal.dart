// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/modal_top_bar_widget.dart';

class SelectClassModal extends StatelessWidget {
  final Class clazz;
  final SelectClassCubit cubit;
  final void Function() switchTabCallback;

  const SelectClassModal({
    Key? key,
    required this.clazz,
    required this.cubit,
    required this.switchTabCallback,
  }) : super(key: key);

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
                clazz.name,
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
                    text: clazz.ownerName,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // TODO:
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
              title: 'Ver Turma',
              width: double.infinity,
              height: Sizes.defaultButtonHeight,
              onPress: () {
                Navigator.pushNamed(
                  context,
                  Routes.classDetails,
                  arguments: {'class': clazz},
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
              title: 'Selecionar Turma',
              width: double.infinity,
              height: Sizes.defaultButtonHeight,
              onPress: () {
                cubit.select(clazz);
                PresentationUtils.showToast('${clazz.name} selecionada!');
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
