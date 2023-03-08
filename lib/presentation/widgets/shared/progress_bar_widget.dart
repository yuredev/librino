import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';

class ProgressBarWidget extends StatelessWidget {
  final Color color;
  final double height;
  final double progression;
  final double borderRadius;

  const ProgressBarWidget({
    super.key,
    required this.color,
    required this.height,
    required this.progression,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: LibrinoColors.lightGray,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (ctx, constraints) => Container(
              width: constraints.maxWidth * (progression / 100),
              height: height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(borderRadius),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
