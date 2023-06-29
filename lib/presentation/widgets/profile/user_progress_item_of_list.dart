import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/widgets/shared/gray_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/progress_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/shimmer_widget.dart';

class UserProgressItemOfList extends StatelessWidget {
  final String? title;
  final int? totalLessons;
  final int? finishedLessons;
  final bool isLoading;

  const UserProgressItemOfList({
    super.key,
    this.isLoading = false,
    this.title,
    this.finishedLessons,
    this.totalLessons,
  });

  @override
  Widget build(BuildContext context) {
    final progress = isLoading
        ? 0.0
        : totalLessons == 0
            ? 0.0
            : (finishedLessons! / totalLessons!) * 100;
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: isLoading
                ? GrayBarWidget(height: 15.5, width: 110)
                : RichText(
                    text: TextSpan(
                      text: 'Módulo: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 15.5,
                      ),
                      children: [
                        TextSpan(
                          text: title,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ProgressBarWidget(
              color: LibrinoColors.grayBlue,
              height: 14,
              progression: progress,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLoading
                  ? GrayBarWidget(height: 15.5, width: 120)
                  : Text(
                      '$finishedLessons/$totalLessons Lições concluídas',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: LibrinoColors.subtitleDarkGray,
                      ),
                    ),
              isLoading
                  ? GrayBarWidget(height: 15.5, width: 100)
                  : Text(
                      '$progress% Concluído',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: LibrinoColors.subtitleDarkGray,
                      ),
                    ),
            ],
          )
        ],
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        border: BorderDirectional(
          bottom: BorderSide(
            color: LibrinoColors.borderGray,
          ),
        ),
      ),
      child: isLoading ? ShimmerWidget(child: content) : content,
    );
  }
}
