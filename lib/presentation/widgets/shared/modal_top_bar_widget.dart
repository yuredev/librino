import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';

class ModalTopBarWidget extends StatelessWidget {
  const ModalTopBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 3.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: LibrinoColors.disabledGray,
      ),
    );
  }
}
