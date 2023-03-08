import 'package:flutter/material.dart';

class QuestionTitleWidget extends StatelessWidget {
  final String title;

  const QuestionTitleWidget(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}
