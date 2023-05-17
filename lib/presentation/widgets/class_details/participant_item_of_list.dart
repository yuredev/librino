import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/presentation/widgets/shared/gray_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/shimmer_widget.dart';

class ParticipantItemOfListWidget extends StatelessWidget {
  final LibrinoUser? participant;
  final bool isLoading;

  const ParticipantItemOfListWidget({
    super.key,
    this.participant,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          width: 53,
          height: 53,
          child: FittedBox(
            child: Container(
              decoration: BoxDecoration(
                color: LibrinoColors.lightGray,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.person,
                  color: LibrinoColors.iconGray,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: GrayBarWidget(
                        height: 15,
                        width: 190,
                      ),
                    )
                  : Text(
                      participant!.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              isLoading
                  ? GrayBarWidget(
                      height: 15,
                      width: 150,
                    )
                  : Text(participant!.email),
            ],
          ),
        )
      ],
    );
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: LibrinoColors.backgroundWhite,
      ),
      child: isLoading ? ShimmerWidget(child: content) : content,
    );
  }
}
