import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';

class ModalTopBarWidgetWidget extends StatelessWidget {
  const ModalTopBarWidgetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: LibrinoColors.disabledGray,
      ),
    );
  }
}
