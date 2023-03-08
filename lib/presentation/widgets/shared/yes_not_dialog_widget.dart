// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class YesNotDialogWidget extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final void Function()? onConfirm;
  final String confirmTitle;
  final String cancelTitle;
  final Color? confirmColor;
  final Color? cancelColor;
  final Color? titleColor;

  const YesNotDialogWidget({
    Key? key,
    required this.context,
    required this.title,
    required this.description,
    this.confirmText = 'Sim',
    this.cancelText = 'Não',
    this.onConfirm,
    this.confirmTitle = 'Sim',
    this.cancelTitle = 'Não',
    this.confirmColor,
    this.cancelColor,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: titleColor),
      ),
      content: SingleChildScrollView(child: Text(description)),
      actions: <Widget>[
        TextButton(
          child: Text(
            cancelTitle,
            style: TextStyle(color: cancelColor),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text(
            style: TextStyle(color: confirmColor),
            confirmTitle,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
            if (onConfirm != null) onConfirm!();
          },
        ),
      ],
    );
  }
}
