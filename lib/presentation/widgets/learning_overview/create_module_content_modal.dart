import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/module/module.dart';

import 'package:librino/presentation/widgets/shared/button_widget.dart';

class CreateModuleContentModal extends StatelessWidget {
  final Module module;

  const CreateModuleContentModal({
    required this.module,
  });

  void _onAddContentPress(BuildContext context) async {
    await Navigator.pushReplacementNamed(
      context,
      Routes.addLessonsToModule,
      arguments: {
        'module': module,
        'hasContent': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const edgeInsets = EdgeInsets.only(
      top: Sizes.modalBottomSheetDefaultTopPadding,
      bottom: Sizes.modalBottomSheetDefaultBottomPadding,
      left: Sizes.defaultScreenHorizontalMargin,
      right: Sizes.defaultScreenHorizontalMargin,
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding: edgeInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                module.imageUrl == null
                    ? Image.asset(
                        'assets/images/generic-module.png',
                        width: MediaQuery.of(context).size.width * 0.28,
                      )
                    : Image.network(
                        module.imageUrl!,
                        width: MediaQuery.of(context).size.width * 0.28,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/generic-module.png',
                            width: MediaQuery.of(context).size.width * 0.28,
                          );
                        },
                      ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Text(
                    module.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: RichText(
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: 'Descrição:\n',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: module.description * 500,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: LibrinoColors.subtitleGray,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Spacer(),
            ButtonWidget(
              onPress: () => _onAddContentPress(context),
              title: 'Adicionar conteúdo',
              height: Sizes.defaultButtonHeight,
              width: double.infinity,
              leftIcon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 14),
            ),
          ],
        ),
      ),
    );
  }
}
