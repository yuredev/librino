import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/presentation/widgets/shared/gray_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
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
    const margin = 3.0;
    final content = InkWellWidget(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.profile,
          arguments: {'user': participant},
        );
      },
      borderRadius: 24,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Row(
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
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
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
                  Container(
                    margin: const EdgeInsets.only(bottom: margin),
                    child: isLoading
                        ? const GrayBarWidget(
                            height: 15,
                            width: 190,
                          )
                        : Text(
                            participant!.name,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: margin),
                    child: isLoading
                        ? const GrayBarWidget(
                            height: 15,
                            width: 150,
                          )
                        : Text(
                            participant!.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: LibrinoColors.subtitleDarkGray,
                            ),
                          ),
                  ),
                  isLoading
                      ? const GrayBarWidget(
                          height: 15,
                          width: 150,
                        )
                      : Text(
                          audityAbilityToString[participant!.auditoryAbility]!,
                          style: TextStyle(
                            fontSize: 14,
                            color: LibrinoColors.subtitleDarkGray,
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: LibrinoColors.backgroundWhite,
      ),
      child: isLoading ? ShimmerWidget(child: content) : content,
    );
  }
}
