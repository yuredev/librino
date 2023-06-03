import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/logic/cubits/class/search/search_class_cubit.dart';
import 'package:librino/logic/cubits/class/search/search_class_state.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_cubit.dart';
import 'package:librino/logic/cubits/subscription/actions/subscription_actions_state.dart';
import 'package:librino/logic/validators/search_class_validator.dart';
import 'package:librino/presentation/screens/subscription_requested_screen.dart';
import 'package:librino/presentation/widgets/search_class/class_found_widget.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';
import 'package:librino/presentation/widgets/shared/info_card_widget.dart';
import 'package:librino/presentation/widgets/shared/search_bar_widget.dart';

class SearchClassScreen extends StatefulWidget {
  const SearchClassScreen({super.key});

  @override
  State<SearchClassScreen> createState() => _SearchClassScreenState();
}

class _SearchClassScreenState extends State<SearchClassScreen> {
  late final SearchClassCubit searchClassCubit = context.read();
  late final SubscriptionActionsCubit subscriptionCubit = context.read();

  final searchBarCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void onSubmit() {
    if (formKey.currentState!.validate()) {
      searchClassCubit.search(searchBarCtrl.text);
    }
  }

  @override
  void dispose() {
    searchClassCubit.reset();
    super.dispose();
  }

  void onClassSubscriptionListen(
    BuildContext context,
    SubscriptionActionsState state,
  ) {
    if (state is SubscriptionRequestedState) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SubscriptionRequestedScreen();
          },
        ),
      );
    }
  }

  void onSearchClassListen(BuildContext context, SearchClassState state) {
    if (state is ClassNotFoundState || state is ClassFoundState) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: LibrinoColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: LibrinoColors.mainDeeper,
        centerTitle: true,
        title: const Text(
          'Procurar Turma',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocConsumer<SearchClassCubit, SearchClassState>(
        listener: onSearchClassListen,
        builder: (context, state) => Column(
          children: [
            const InfoCardWidget(
              title: 'Inscrição em Turmas',
              description:
                  'Digite o código da turma em que você deseja se matricular. Uma solicitação de inscrição será enviada ao instrutor responsável.',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.defaultScreenHorizontalMargin,
                15,
                Sizes.defaultScreenHorizontalMargin,
                0,
              ),
              child: SearchBarWidget(
                validator: SearchClassValidator.searchBarValidator,
                formKey: formKey,
                controller: searchBarCtrl,
                hint: 'Código da turma',
                onSendButtonPress: onSubmit,
                onSubmit: (_) => onSubmit(),
                sendButtonColor: LibrinoColors.main,
              ),
            ),
            if (state is SearchingClassState)
              Container(
                margin: const EdgeInsets.only(top: 45),
                child: IllustrationWidget(
                  isAnimation: true,
                  title: 'Procurando Turma...',
                  subtitle: '',
                  illustrationName: 'searching-class.json',
                  fontSize: 17.2,
                ),
              )
            else if (state is SearchClassErrorState)
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: IllustrationWidget(
                  isAnimation: true,
                  title: 'Erro inesperado ao buscar turma',
                  subtitle: 'Verifique sua conexão com a internet.',
                  illustrationName: 'error.json',
                  imageWidth: MediaQuery.of(context).size.width * 0.6,
                  fontSize: 18,
                  textImageSpacing: 22,
                ),
              )
            else if (state is ClassNotFoundState)
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: IllustrationWidget(
                  isAnimation: true,
                  title: 'Turma não encontrada',
                  subtitle:
                      'Certifique-se que o código que você digitou é um código valido do Librino',
                  illustrationName: 'not-found.json',
                  imageWidth: MediaQuery.of(context).size.width * 0.7,
                  fontSize: 18,
                  textImageSpacing: 0,
                ),
              )
            else if (state is ClassFoundState)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Sizes.defaultScreenHorizontalMargin,
                  26,
                  Sizes.defaultScreenHorizontalMargin,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Turma encontrada: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ClassFoundWidget(
                      clazz: state.clazz,
                      onPress: () {},
                    ),
                  ],
                ),
              )
            else if (state is InitialSearchClassState)
              Container(
                margin: const EdgeInsets.only(top: 45),
                child: IllustrationWidget(
                  title: 'Inscrição em Turmas',
                  subtitle:
                      'Insira um código válido de turma acima para poder solicitar sua inscrição em uma turma do Librino',
                  illustrationName: 'team.png',
                  imageWidth: MediaQuery.of(context).size.width * 0.4,
                  fontSize: 17.2,
                ),
              ),
            if (state is ClassFoundState) Spacer(),
            if (state is ClassFoundState)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Sizes.defaultScreenHorizontalMargin,
                  0,
                  Sizes.defaultScreenHorizontalMargin,
                  Sizes.defaultScreenBottomMargin,
                ),
                child: BlocConsumer<SubscriptionActionsCubit,
                    SubscriptionActionsState>(
                  listener: onClassSubscriptionListen,
                  builder: (context, subsState) => ButtonWidget(
                    height: 63,
                    width: double.infinity,
                    title: 'Solicitar Inscrição',
                    color: LibrinoColors.mainDeeper,
                    isLoading: subsState is RequestingSubscriptionState,
                    onPress: () =>
                        subscriptionCubit.requestSubscription(state.clazz.id!),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
