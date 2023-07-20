import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/question_filter.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/modal_top_bar_widget.dart';

class QuestionFilterModal extends StatefulWidget {
  final QuestionFilter? questionFilter;

  const QuestionFilterModal({
    super.key,
    this.questionFilter,
  });

  @override
  State<QuestionFilterModal> createState() => _QuestionFilterModalState();
}

class _QuestionFilterModalState extends State<QuestionFilterModal> {
  QuestionType? questionType;
  late final bool hideNullAnswer;

  @override
  void initState() {
    super.initState();
    hideNullAnswer = widget.questionFilter?.questionType != null;
    questionType = widget.questionFilter?.questionType;
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
    final list = QuestionType.values
        .map((e) => DropdownMenuItem(
              value: e,
              child: Container(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  questionTypeToString[e]!,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ))
        .toList();
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
              child: const ModalTopBarWidget(),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 16, 18, 16),
            child: Text(
              'Filtrar Questões',
              style: TextStyle(
                color: LibrinoColors.main,
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: double.infinity,
            child: DropdownButtonHideUnderline(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: LibrinoColors.borderGrayDarker,
                  ),
                  borderRadius:
                      BorderRadius.circular(Sizes.defaultInputBorderRadius),
                ),
                child: DropdownButton<QuestionType>(
                  selectedItemBuilder: (context) {
                    return QuestionType.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                questionTypeToString[e]!,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        )
                        .toList()
                      ..add(
                        DropdownMenuItem(
                          child: Container(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              'Tipo da questão',
                              style: TextStyle(
                                fontSize: 14,
                                color: LibrinoColors.grayPlaceholder,
                              ),
                            ),
                          ),
                        ),
                      );
                  },
                  value: questionType,
                  onChanged: (value) {
                    setState(() {
                      questionType = value;
                    });
                  },
                  hint: Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      'Selecionar',
                      style: TextStyle(
                        fontSize: 14,
                        color: LibrinoColors.grayPlaceholder,
                      ),
                    ),
                  ),
                  items: hideNullAnswer
                      ? list
                      : (list
                        ..add(
                          DropdownMenuItem(
                            child: Container(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                'Qualquer',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        )),
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.only(
              bottom: 13,
            ),
            child: ButtonWidget(
              title: 'Aplicar Filtros',
              width: double.infinity,
              height: Sizes.defaultButtonHeight,
              onPress: () {
                Navigator.pop(
                  context,
                  QuestionFilter(questionType: questionType),
                );
              },
              padding: EdgeInsets.symmetric(vertical: 12),
              leftIcon: Icon(Icons.tune),
            ),
          )
        ],
      ),
    );
  }
}
