
import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';

class InfoCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final EdgeInsets padding;

  const InfoCardWidget({
    Key? key,
    required this.title,
    required this.description,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Sizes.defaultScreenHorizontalMargin,
      vertical: 16,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.infinity,
      color: LibrinoColors.backgroundGray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              color: LibrinoColors.mainDeeper,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: LibrinoColors.textLightBlack,
            ),
          ),
        ],
      ),
    );
  }
}
