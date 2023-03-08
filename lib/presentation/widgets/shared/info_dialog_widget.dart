import 'package:flutter/material.dart';

class InfoDialogWidget extends StatelessWidget {
  final String text;
  final String imageName;

  const InfoDialogWidget({
    Key? key,
    required this.text,
    required this.imageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 13, top: 20),
        titlePadding: const EdgeInsets.fromLTRB(18, 27, 18, 0),
        title: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        content: Image.asset(
          'assets/images/$imageName',
          height: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
    );
  }
}
