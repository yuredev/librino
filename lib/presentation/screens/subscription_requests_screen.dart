import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/subscription/subscription.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_cubit.dart';
import 'package:librino/logic/cubits/subscription/load/load_subscriptions_cubit.dart';
import 'package:librino/logic/cubits/subscription/load/load_subscriptions_state.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';
import 'package:librino/presentation/widgets/shared/initial_app_bar.dart';
import 'package:librino/presentation/widgets/subscription_requests/subscription_item_of_list_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SubscriptionRequestsScreen extends StatefulWidget {
  const SubscriptionRequestsScreen({super.key});

  @override
  State<SubscriptionRequestsScreen> createState() =>
      _SubscriptionRequestsScreenState();
}

class _SubscriptionRequestsScreenState
    extends State<SubscriptionRequestsScreen> {
  late final LoadSubscriptionsCubit loadSubscriptionsCubit = context.read();
  late final SubscriptionActionsCubit subsActionsCubit = context.read();
  var mainTab = 0;
  var secondTab = 0;

  List<Subscription> getSubsByStage(
      List<Subscription> subs, SubscriptionStage subscriptionStage) {
    return subs.where((s) => s.subscriptionStage == subscriptionStage).toList();
  }

  Widget buildSecondTabButtons() {
    return SliverPadding(
      padding: EdgeInsets.only(
        right: Sizes.defaultScreenHorizontalMargin,
        left: Sizes.defaultScreenHorizontalMargin,
        top: 16,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                splashColor: LibrinoColors.main.withOpacity(0.4),
                onTap: () {
                  setState(() => secondTab = 1);
                },
                child: Container(
                  decoration: secondTab == 1
                      ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: LibrinoColors.main,
                              width: 1.7,
                            ),
                          ),
                        )
                      : null,
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    'Reprovadas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              InkWell(
                splashColor: LibrinoColors.main.withOpacity(0.4),
                onTap: () {
                  setState(() => secondTab = 0);
                },
                child: Container(
                  decoration: secondTab == 0
                      ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: LibrinoColors.main,
                              width: 1.7,
                            ),
                          ),
                        )
                      : null,
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    'Aprovadas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadSubscriptionsCubit.load,
      child: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (_, authState) => authState is LoggedInState,
        builder: (context, state) {
          final user = (state as LoggedInState).user;
          return BlocBuilder<LoadSubscriptionsCubit, LoadSubscriptionsState>(
            builder: (context, state) {
              final pendingSubs = state is SubscriptionsLoadedState
                  ? getSubsByStage(
                      state.subscriptions,
                      SubscriptionStage.requested,
                    )
                  : <Subscription>[];
              final approvedSubs = state is SubscriptionsLoadedState
                  ? getSubsByStage(
                      state.subscriptions,
                      SubscriptionStage.approved,
                    )
                  : <Subscription>[];
              final repprovedSubs = state is SubscriptionsLoadedState
                  ? getSubsByStage(
                      state.subscriptions,
                      SubscriptionStage.repproved,
                    )
                  : <Subscription>[];
              final showNoDataMessage = mainTab == 0 && pendingSubs.isEmpty ||
                  mainTab == 1 && secondTab == 0 && approvedSubs.isEmpty ||
                  mainTab == 1 && secondTab == 1 && repprovedSubs.isEmpty;
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      InitialAppBar(
                        conclusionPercentage: 80,
                        user: user,
                        firstLineText: 'Solicitações de matrícula',
                        firstLineTextSize: 20,
                        bottomWidget: Center(
                          child: LayoutBuilder(
                            builder: (ctx, consts) => Container(
                              margin: const EdgeInsets.only(top: 22),
                              child: ToggleSwitch(
                                minHeight: 54,
                                // cornerRadius: 14.0,
                                cornerRadius: 40.0,
                                minWidth: consts.maxWidth * 0.49,
                                activeBgColors: [
                                  const [LibrinoColors.main],
                                  const [LibrinoColors.main]
                                ],
                                activeFgColor: LibrinoColors.backgroundWhite,
                                inactiveBgColor: LibrinoColors.lightGrayDarker,
                                inactiveFgColor: Colors.black,
                                initialLabelIndex: mainTab,
                                totalSwitches: 2,
                                labels: ['Pendentes', 'Respondidas'],
                                radiusStyle: true,
                                fontSize: 18,
                                onToggle: (index) {
                                  if (index == null) return;
                                  setState(() => mainTab = index);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  if (mainTab == 1) buildSecondTabButtons(),
                  if (state is LoadingSubcriptionsState)
                    SliverPadding(
                      padding: EdgeInsets.only(
                        left: Sizes.defaultScreenHorizontalMargin,
                        right: Sizes.defaultScreenHorizontalMargin,
                        top: 20,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          List.generate(
                            6,
                            (index) => Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: SubscriptionItemOfList(isLoading: true),
                            ),
                          ),
                        ),
                      ),
                    )
                  else if (state is LoadSubscriptionsErrorState)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.defaultScreenHorizontalMargin,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            IllustrationWidget(
                              illustrationName: 'error.json',
                              isAnimation: true,
                              title: state.errorMessage,
                              subtitle: 'Verifique sua conexão com a internet',
                              imageWidth:
                                  MediaQuery.of(context).size.width * 0.45,
                            )
                          ],
                        ),
                      ),
                    )
                  else if (showNoDataMessage)
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        Sizes.defaultScreenHorizontalMargin,
                        40,
                        Sizes.defaultScreenHorizontalMargin,
                        0,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            IllustrationWidget(
                              illustrationName: 'no-data.png',
                              title: 'Sem resultados',
                              subtitle:
                                  'Sem solicitações de matrícula nesta seção',
                              imageWidth:
                                  MediaQuery.of(context).size.width * .38,
                            )
                          ],
                        ),
                      ),
                    )
                  else if (state is SubscriptionsLoadedState &&
                      state.subscriptions.isNotEmpty)
                    SliverPadding(
                      padding: EdgeInsets.only(
                        left: Sizes.defaultScreenHorizontalMargin,
                        right: Sizes.defaultScreenHorizontalMargin,
                        top: 20,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            late final List<Subscription> subs;
                            if (mainTab == 0) {
                              subs = pendingSubs;
                            } else if (secondTab == 0) {
                              subs = approvedSubs;
                            } else {
                              subs = repprovedSubs;
                            }
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: SubscriptionItemOfList(
                                subscription: subs[index],
                              ),
                            );
                          },
                          childCount: mainTab == 0
                              ? pendingSubs.length
                              : secondTab == 0
                                  ? approvedSubs.length
                                  : repprovedSubs.length,
                        ),
                      ),
                    )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
