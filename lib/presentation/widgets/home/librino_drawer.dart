// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:librino/core/constants/colors.dart';
import 'package:librino/data/models/user.dart';
import 'package:librino/presentation/visual_alerts.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';

class LibrinoDrawer extends StatelessWidget {
  final User user;

  const LibrinoDrawer({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btnStyle = TextButton.styleFrom(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(
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
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Image.asset(
                        'assets/images/user.png',
                        width: consts.maxWidth * .42,
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
                        onPress: () {},
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
                      TextButton(
                        style: btnStyle,
                        onPressed: () {},
                        child: Text(
                          'Sobre o Librino',
                          style: textBtnStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      TextButton(
                        style: btnStyle,
                        onPressed: () {},
                        child: Text(
                          'Sobre o desenvolvedor',
                          style: textBtnStyle,
                        ),
                      ),
                      TextButton(
                        style: btnStyle,
                        onPressed: () {},
                        child: Text(
                          'Avaliar',
                          style: textBtnStyle,
                        ),
                      ),
                      TextButton(
                        style: btnStyle,
                        onPressed: () {},
                        child: Text(
                          'Remover conta',
                          style: textBtnStyle,
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        style: btnStyle.copyWith(
                          alignment: Alignment.center,
                        ),
                        onPressed: () async {
                          VisualAlerts.showYesNotDialog(
                            context,
                            title: 'Deseja sair?',
                            description: 'Você precisará se autenticar novamente para usar o app',
                          );
                        },
                        child: Text(
                          'Sair',
                          style: TextStyle(
                            color: LibrinoColors.textLightBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
