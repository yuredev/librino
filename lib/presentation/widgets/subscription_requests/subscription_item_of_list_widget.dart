import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/core/utils/converters.dart';
import 'package:librino/data/models/subscription/subscription.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_cubit.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_state.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/gray_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:librino/presentation/widgets/shared/shimmer_widget.dart';

class SubscriptionItemOfList extends StatelessWidget {
  final Subscription? subscription;
  final bool isLoading;

  const SubscriptionItemOfList({
    super.key,
    this.subscription,
    this.isLoading = false,
  });

  Widget _buildField(String key, String value) {
    return RichText(
      text: TextSpan(
        text: key,
        style: TextStyle(
          height: 1.3,
          fontWeight: FontWeight.w400,
          color: LibrinoColors.textLightBlack,
          fontSize: 15,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: LibrinoColors.subtitleGray,
            ),
          ),
        ],
      ),
    );
  }

  void approveReprove(BuildContext context, SubscriptionStage stage) async {
    final mustContinue = await PresentationUtils.showConfirmActionDialog(
          context,
          title:
              '${stage == SubscriptionStage.approved ? "Aprovar" : "Reprovar"} solicitação de matrícula?',
          description:
              'Após esta ação não será mais possível remover o usuário matrículado',
        ) ??
        false;
    if (context.mounted && mustContinue) {
      final cubit = context.read<SubscriptionActionsCubit>();
      if (stage == SubscriptionStage.approved) {
        cubit.approve(subscription!.id!);
      } else {
        cubit.repprove(subscription!.id!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const iconMap = {
      SubscriptionStage.requested: Icons.schedule,
      SubscriptionStage.repproved: Icons.error_outline,
      SubscriptionStage.approved: Icons.check_circle_outline,
    };
    final iconColorMap = {
      SubscriptionStage.requested: LibrinoColors.iconGray,
      SubscriptionStage.repproved: Colors.red.withOpacity(0.8),
      SubscriptionStage.approved: LibrinoColors.main.withOpacity(0.8),
    };
    final content = InkWellWidget(
      borderRadius: 20,
      onTap: () {
        // TODO: fazer abrir tela da turma
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16, top: 4),
                  child: Icon(
                    iconMap[subscription?.subscriptionStage] ?? Icons.circle,
                    color: iconColorMap[subscription?.subscriptionStage] ??
                        LibrinoColors.iconGray,
                    size: 35,
                  ),
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (previous, current) => current is LoggedInState,
                  builder: (context, state) {
                    final isInstructor =
                        (state as LoggedInState).user.isInstructor;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isLoading
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                child:
                                    const GrayBarWidget(height: 18, width: 140),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  subscription!.className!,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                        isLoading
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 3),
                                child:
                                    const GrayBarWidget(height: 14, width: 160),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                alignment: Alignment.centerLeft,
                                child: isInstructor
                                    ? _buildField(
                                        'Solicitante: ',
                                        subscription?.subscriberName ?? '--',
                                      )
                                    : _buildField(
                                        'Instrutor: ',
                                        subscription!.responsibleName!,
                                      ),
                              ),
                        isLoading
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 3),
                                child:
                                    const GrayBarWidget(height: 14, width: 100),
                              )
                            : _buildField(
                                'Data: ',
                                Converters.dateToBRLFormat(
                                  subscription!.requestDate,
                                ),
                              ),
                      ],
                    );
                  },
                )
              ],
            ),
            BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (previous, current) => current is LoggedInState,
              builder: (context, state) {
                return (state as LoggedInState).user.profileType ==
                            ProfileType.instructor &&
                        (subscription?.subscriptionStage !=
                            SubscriptionStage.approved)
                    ? BlocBuilder<SubscriptionActionsCubit,
                        SubscriptionActionsState>(
                        builder: (context, actionsState) => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 12,
                                top: 12,
                              ),
                              child: const Divider(height: 0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (subscription?.subscriptionStage !=
                                    SubscriptionStage.repproved)
                                  ButtonWidget(
                                    onPress: isLoading
                                        ? null
                                        : () {
                                            approveReprove(
                                              context,
                                              SubscriptionStage.repproved,
                                            );
                                          },
                                    isLoading: actionsState
                                        is RepprovingSubscriptionState,
                                    title: 'Reprovar',
                                    color: LibrinoColors.whiteRed,
                                    textColor: Colors.red,
                                    height: 28,
                                    width: 90,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 6,
                                    ),
                                  ),
                                if (subscription?.subscriptionStage !=
                                    SubscriptionStage.approved)
                                  SizedBox(width: 12),
                                ButtonWidget(
                                  onPress: isLoading
                                      ? null
                                      : () {
                                          approveReprove(
                                            context,
                                            SubscriptionStage.approved,
                                          );
                                        },
                                  title: 'Aprovar',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  height: 28,
                                  width: 90,
                                  isLoading: actionsState
                                      is ApprovingSubscriptionState,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 6,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox();
              },
            ),
          ],
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: LibrinoColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isLoading ? ShimmerWidget(child: content) : content,
    );
  }
}
