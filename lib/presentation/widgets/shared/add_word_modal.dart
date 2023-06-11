import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/modal_top_bar_widget.dart';

class AddWordModal extends StatefulWidget {
  const AddWordModal({super.key});

  @override
  State<AddWordModal> createState() => _AddWordModalState();
}

class _AddWordModalState extends State<AddWordModal> {
  final wordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void submit() {
    if (formKey.currentState!.validate()) {
      final word = wordCtrl.text.trim();
      Navigator.pop(
        context,
        word.length < 2
            ? word
            : '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const topBarSpacing = 17.0;
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: LibrinoColors.grayInputBorder,
      ),
      borderRadius: BorderRadius.circular(Sizes.defaultInputBorderRadius),
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: topBarSpacing, horizontal: 24),
      height: MediaQuery.of(context).size.height * .55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: topBarSpacing,
              ),
              child: ModalTopBarWidget(),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 16, 18, 16),
            child: Text(
              'Adicionar Palavra',
              style: TextStyle(
                color: LibrinoColors.main,
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Form(
            key: formKey,
            child: TextFormField(
              controller: wordCtrl,
              validator: (text) {
                if (text?.trim().isEmpty ?? true) {
                  return 'Preencha a palavra';
                }
                if (text!.trim().split(' ').length >= 2) {
                  return 'O campo deve conter somente uma palavra';
                }
                if (text.trim().length > 25) {
                  return 'A palavra deve possuir menos de 25 caracteres';
                }
                return null;
              },
              onFieldSubmitted: (_) => submit(),
              autocorrect: false,
              style: TextStyle(fontSize: 15),
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                filled: true,
                fillColor: LibrinoColors.backgroundWhite,
                prefixIcon: const Icon(
                  Icons.text_fields_rounded,
                  size: 22,
                ),
                contentPadding: const EdgeInsets.only(left: 22),
                label: const Text('Preencha o campo'),
                enabledBorder: inputBorder,
                disabledBorder: inputBorder,
                focusedBorder: inputBorder,
                border: inputBorder,
                labelStyle: TextStyle(
                  color: LibrinoColors.grayPlaceholder,
                ),
                isDense: true,
              ),
            ),
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.only(
              bottom: 13,
            ),
            child: ButtonWidget(
              title: 'Adicionar',
              width: double.infinity,
              height: Sizes.defaultButtonHeight,
              onPress: submit,
            ),
          )
        ],
      ),
    );
  }
}
