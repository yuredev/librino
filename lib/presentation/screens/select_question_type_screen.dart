import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/presentation/widgets/shared/list_tile_widget.dart';

class SelectQuestionTypeScreen extends StatelessWidget {
  const SelectQuestionTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Criar Questão',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(
                bottom: 22,
                left: Sizes.defaultScreenHorizontalMargin,
              ),
              child: Text(
                'Selecionar Tipo da Questão',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: LibrinoColors.mainDeeper),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTileWidget(
                fontSize: 15.5,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: Sizes.defaultScreenHorizontalMargin + 2,
                ),
                icon: Icons.translate,
                borderRadius: 0,
                elevation: 0.4,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.createLIBRASToWordQuestion,
                  );
                },
                title: 'Tradução de palavra: LIBRAS <-> Português escrito',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTileWidget(
                fontSize: 15.5,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: Sizes.defaultScreenHorizontalMargin + 2,
                ),
                icon: Icons.sign_language_outlined,
                borderRadius: 0,
                elevation: 0.4,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.createWordToLIBRASQuestion,
                  );
                },
                title: 'Tradução de palavra: Português escrito <-> LIBRAS',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTileWidget(
                fontSize: 15.5,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: Sizes.defaultScreenHorizontalMargin + 2,
                ),
                icon: Icons.translate,
                borderRadius: 0,
                elevation: 0.4,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.createLIBRASToPhraseQuestion,
                  );
                },
                title: 'Tradução de frase: LIBRAS <-> Português escrito',
              ),
            ),
            ListTileWidget(
              fontSize: 15.5,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: Sizes.defaultScreenHorizontalMargin + 2,
              ),
              icon: Icons.sign_language_outlined,
              borderRadius: 0,
              elevation: 0.4,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.createPhraseToLIBRASQuestion,
                );
              },
              title: 'Tradução de frase: Português escrito <-> LIBRAS',
            ),
          ],
        ),
      ),
    );
  }
}
