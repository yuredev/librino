import 'package:flutter/material.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';

class QuestionScaffold extends StatelessWidget {
  final void Function() onPress;

  final Widget body;

  const QuestionScaffold({
    super.key,
    required this.body,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return LibrinoScaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 23,
          vertical: 20,
        ),
        child: ButtonWidget(
          title: 'Checar',
          width: double.infinity,
          height: Sizes.defaultButtonHeight,
          onPress: onPress,
        ),
      ),
      body: body,
    );
  }
}
