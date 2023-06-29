import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_cubit.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/gray_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:librino/presentation/widgets/shared/shimmer_widget.dart';

class ParticipantItemOfListWidget extends StatelessWidget {
  final LibrinoUser? participant;
  final bool isLoading;
  final void Function()? onPress;
  final String classId;

  const ParticipantItemOfListWidget({
    super.key,
    this.participant,
    this.onPress,
    this.isLoading = false,
    required this.classId,
  });

  void onRemoveParticipantPress(BuildContext context) async {
    final shouldRemove = await PresentationUtils.showConfirmActionDialog(
          context,
          title: 'Remover o participante da turma?',
          description:
              'Para adicioná-lo novamente ele precisará requisitar uma nova inscrição',
        ) ??
        false;
    if (shouldRemove && context.mounted) {
      context
          .read<SubscriptionActionsCubit>()
          .removeUserFromClass(participant!.id, classId);
    }
  }

  @override
  Widget build(BuildContext context) {
    const margin = 3.0;
    final content = InkWellWidget(
      onTap: onPress,
      borderRadius: 24,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              clipBehavior: Clip.antiAlias,
              child: FittedBox(
                child: Container(
                  decoration: BoxDecoration(
                    color: LibrinoColors.lightGray,
                  ),
                  child: participant == null || participant!.photoURL == null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(
                            Icons.person,
                            color: LibrinoColors.iconGray,
                          ),
                        )
                      : Image.network(
                          participant!.photoURL!,
                          fit: BoxFit.cover,
                          width: 53,
                          height: 53,
                        ),
                ),
              ),
            ),
            Expanded(
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
                            participant!.completeName,
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
            ),
            InkWellWidget(
              borderRadius: 50,
              onTap: isLoading ? null : () => onRemoveParticipantPress(context),
              child: Tooltip(
                message: 'Remover participante',
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red.withOpacity(0.5),
                  ),
                ),
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
