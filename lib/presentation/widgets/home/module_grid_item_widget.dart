import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/widgets/shared/gray_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:librino/presentation/widgets/shared/progress_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/shimmer_widget.dart';

class ModuleGridItemWidget extends StatelessWidget {
  final void Function()? onPress;
  final String? title;
  final double? conclusionPercentage;
  final String? imageUrl;
  final bool isLoading;

  const ModuleGridItemWidget({
    super.key,
    this.onPress,
    this.title,
    this.conclusionPercentage,
    this.imageUrl,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    const spacing = 8.0;
    final content = InkWellWidget(
      onTap: onPress,
      borderRadius: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: spacing),
              child: isLoading
                  ? const GrayBarWidget(height: 45, width: 45)
                  : Image.network(
                      imageUrl!,
                      height: 45,
                    ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: spacing - 5),
              child: isLoading
                  ? const GrayBarWidget(height: 12, width: 90)
                  : Text(
                      title!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: spacing),
              child: isLoading
                  ? const GrayBarWidget(height: 12, width: 90)
                  : Text(
                      'Você completou ${conclusionPercentage!.floor()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: LibrinoColors.subtitleGray,
                      ),
                    ),
            ),
            isLoading
                ? GrayBarWidget(height: 14, width: double.infinity)
                : ProgressBarWidget(
                    color: LibrinoColors.mainOrange,
                    height: 12,
                    progression: conclusionPercentage!,
                  )
          ],
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: LibrinoColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.03),
            spreadRadius: 1.25,
            blurRadius: 15,
          ),
        ],
      ),
      child: isLoading ? ShimmerWidget(child: content) : content,
    );
  }
}
