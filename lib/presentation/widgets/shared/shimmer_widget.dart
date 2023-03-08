import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget child;

  const ShimmerWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: LibrinoColors.shimmerGray,
      highlightColor: Colors.white,
      child: child,
    );
  }
}
