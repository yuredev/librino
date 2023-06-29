// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/user/actions/user_actions_cubit.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/confirm_password_modal.dart';
import 'package:url_launcher/url_launcher.dart';

class LibrinoDrawer extends StatelessWidget {
  final LibrinoUser user;
  final UserActionsCubit userCRUDCubit;

  const LibrinoDrawer({
    Key? key,
    required this.user,
    required this.userCRUDCubit,
  }) : super(key: key);

  Future<void> _launchUrl(BuildContext context, String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      PresentationUtils.showSnackBar(context, 'message', isErrorMessage: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = context.read();
    final btnStyle = TextButton.styleFrom(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(
        horizontal: 39,
        vertical: 13,
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    const textBtnStyle = TextStyle(
      color: LibrinoColors.subtitleGray,
      fontWeight: FontWeight.w600,
      fontSize: 14.5,
    );
    const topColor = LibrinoColors.backgroundGray;
    const bottomColor = LibrinoColors.backgroundWhite;
    return Drawer(
      width: MediaQuery.of(context).size.width * .65,
      backgroundColor: topColor,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, consts) => Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30),
                width: double.infinity,
                color: topColor,
                child: Column(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: user.photoURL == null
                          ? Image.asset(
                              'assets/images/user2.png',
                              width: consts.maxWidth * .42,
                              height: consts.maxWidth * .42,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              user.photoURL!,
                              width: consts.maxWidth * .42,
                              height: consts.maxWidth * .42,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        user.email,
                        style: TextStyle(
                          color: LibrinoColors.subtitleGray,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: ButtonWidget(
                        title: 'Editar Perfil',
                        height: 20,
                        width: consts.maxWidth / 2,
                        fontSize: 11,
                        borderRadius: 40,
                        onPress: () {
                          Scaffold.of(context).closeEndDrawer();
                          Navigator.pushNamed(
                            context,
                            Routes.editProfile,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 20,
                  ),
                  color: bottomColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // TextButton(
                      //   style: btnStyle,
                      //   onPressed: () {},
                      //   child: Text(
                      //     'Sobre o Librino',
                      //     style: textBtnStyle,
                      //     textAlign: TextAlign.left,
                      //   ),
                      // ),
                      TextButton(
                        style: btnStyle,
                        onPressed: () {
                          _launchUrl(context, 'https://github.com/yuredev');
                        },
                        child: Text(
                          'Sobre o desenvolvedor',
                          style: textBtnStyle,
                        ),
                      ),
                      // TextButton(
                      //   style: btnStyle,
                      //   onPressed: () {},
                      //   child: Text(
                      //     'Avaliar',
                      //     style: textBtnStyle,
                      //   ),
                      // ),
                      TextButton(
                        style: btnStyle,
                        onPressed: () async {
                          final shouldRemove =
                              await PresentationUtils.showConfirmActionDialog(
                                    context,
                                    title: 'Deseja remover sua conta?',
                                    description:
                                        'Sua conta será removida e não poderá ser recuperada',
                                  ) ??
                                  false;
                          if (shouldRemove) {
                            Scaffold.of(context).closeEndDrawer();
                            PresentationUtils.showBottomModal(
                              context,
                              BlocProvider<UserActionsCubit>.value(
                                value: userCRUDCubit,
                                child: ConfirmPasswordModal(),
                              ),
                            );
                            // userCRUDCubit.removeAccount('yure123');
                          }
                        },
                        child: const Text('Remover conta', style: textBtnStyle),
                      ),
                      Spacer(),
                      TextButton(
                        style: btnStyle.copyWith(
                          alignment: Alignment.center,
                        ),
                        onPressed: () async {
                          final deveSair =
                              await PresentationUtils.showYesNotDialog(
                                    context,
                                    title: 'Deseja sair?',
                                    description:
                                        'Você precisará se autenticar novamente para usar o app',
                                  ) ??
                                  false;
                          if (deveSair) {
                            authCubit.signOut();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 4),
                              child: const Icon(
                                Icons.logout,
                                color: LibrinoColors.textLightBlack,
                                size: 22,
                              ),
                            ),
                            const Text(
                              'Sair',
                              style: TextStyle(
                                color: LibrinoColors.textLightBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
