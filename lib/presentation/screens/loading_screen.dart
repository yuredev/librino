import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';

class LoadingScreen extends StatelessWidget {
  final String moduleId;

  const LoadingScreen({
    super.key,
    required this.moduleId,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LibrinoColors.backgroundGray,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: IllustrationWidget(
              illustrationName: 'learning.json',
              title: 'Carregando exercício.\nAguarde...',
              isAnimation: true,
              imageWidth: MediaQuery.of(context).size.width * 0.7,
              fontSize: 14,
              textImageSpacing: 28,
            ),
          ),
        ],
      ),
    );
  }
}
