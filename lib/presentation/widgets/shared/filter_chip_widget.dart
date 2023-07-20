// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';


class FilterChipWidget extends StatelessWidget {
  final void Function() aoPressionarFechar;
  final String titulo;

  const FilterChipWidget({
    Key? key,
    required this.titulo,
    required this.aoPressionarFechar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 4,
        right: 8,
        left: 4,
      ),
      decoration: BoxDecoration(
        color: LibrinoColors.chipBlue,
        borderRadius: BorderRadius.circular(43),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: 'Remover filtro',
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: LibrinoColors.backgroundWhite,
                borderRadius: BorderRadius.circular(43),
              ),
              child: InkWellWidget(
                borderRadius: 43,
                onTap: aoPressionarFechar,
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: const FittedBox(
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(left: 5),
              child: Text(titulo),
            ),
          )
        ],
      ),
    );
  }
}
