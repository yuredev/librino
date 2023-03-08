import 'package:flutter/material.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';

class QuestionScaffold extends StatelessWidget {
  final Widget body;

  const QuestionScaffold({super.key, required this.body});

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
          height: 53,
          onPress: () {},
        ),
      ),
      body: body,
    );
  }
}
