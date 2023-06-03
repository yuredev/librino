import 'package:flutter/material.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:lottie/lottie.dart';

class SubscriptionRequestedScreen extends StatelessWidget {
  const SubscriptionRequestedScreen({super.key});

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
                      'Inscrição na turma solicitada!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: const Text(
                      'Você pode acompanhar a solicitação na aba solicitações do app',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ButtonWidget(
                    title: 'OK',
                    height: 42,
                    width: 100,
                    onPress: () => Navigator.pop(context),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
