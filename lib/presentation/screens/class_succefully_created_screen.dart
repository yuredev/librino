import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class ClassSuccefullyCreatedScreen extends StatelessWidget {
  final Class clazz;

  const ClassSuccefullyCreatedScreen({super.key, required this.clazz});

  void onShareClassPress() {
    Share.share(
      'Copie e cole o código ${clazz.id} para entrar na turma ${clazz.name} do Librino',
    );
  }

  void onCopyToClipboardPress(BuildContext context) {
    Clipboard.setData(ClipboardData(text: clazz.id)).then(
      (value) => PresentationUtils.showSnackBar(
        context,
        'Código da turma copiado para a área de transferência',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.defaultScreenHorizontalMargin,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Tooltip(
                    message: 'Fechar',
                    child: InkWellWidget(
                      borderRadius: 50,
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Lottie.asset(
                      'assets/animations/document-created.json',
                      width: MediaQuery.of(context).size.width * 0.52,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      'Turma criada com sucesso!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .75,
                    margin: const EdgeInsets.only(bottom: 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'O código da turma é\n',
                        style: TextStyle(
                          color: LibrinoColors.subtitleGray,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                        children: [
                          TextSpan(
                            text: clazz.id,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          const TextSpan(
                            text: '\nToque em copiar ou compartilhar',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ButtonWidget(
                      title: 'Copiar Código',
                      color: LibrinoColors.backgroundWhite,
                      textColor: Colors.black,
                      height: 60,
                      width: double.infinity,
                      onPress: () => onCopyToClipboardPress(context),
                      borderWidth: 0.5,
                      borderColor: Colors.black12,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  ButtonWidget(
                    title: 'Compartilhar',
                    height: 60,
                    width: double.infinity,
                    onPress: onShareClassPress,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
