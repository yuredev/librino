import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:librino/core/constants/colors.dart';
import 'package:librino/data/models/class/class.dart';

class ClassFoundWidget extends StatelessWidget {
  final Class clazz;
  final VoidCallback onPress;
  final bool isReadOnly;

  const ClassFoundWidget({
    Key? key,
    required this.clazz,
    required this.onPress,
    this.isReadOnly = false,
  }) : super(key: key);

  Widget buildField(String key, String value) {
    return RichText(
      text: TextSpan(
        text: key,
        style: TextStyle(
          height: 1.3,
          fontWeight: FontWeight.w500,
          color: LibrinoColors.textLightBlack,
          fontSize: 17,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: LibrinoColors.subtitleGray,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: LibrinoColors.backgroundGray,
          border: const Border(
            left: BorderSide(color: LibrinoColors.mainDeeper, width: 8),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -8,
              right: -10,
              child: Icon(
                Icons.groups,
                color: Colors.black.withOpacity(0.05),
                size: 190,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, consts) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              clazz.name,
                              style: GoogleFonts.roboto(
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                                color: LibrinoColors.mainDeeper,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: buildField('Instrutor: ', clazz.ownerName ?? '--'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: buildField('Descrição:\n', clazz.description),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: buildField(
                      '',
                      '${clazz.participantsCount} Participante${clazz.participantsCount == 1 ? '' : 's'}',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
