import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/classes/select_class_modal.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';

class ClassWidget extends StatelessWidget {
  final Color color;
  final Color textColor;
  final bool disabled;

  const ClassWidget({
    super.key,
    this.disabled = false,
    required this.color,
    required this.textColor,
  });

  Widget buildField(String key, String value) {
    return RichText(
      text: TextSpan(
        text: key,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWellWidget(
        borderRadius: 24,
        onTap: disabled
            ? null
            : () {
                PresentationUtils.showBottomModal(context, SelectClassModal());
              },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.school,
                  size: 45,
                  color: LibrinoColors.textLightBlack.withOpacity(0.25),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 3.5),
                    child: buildField('LIBRAS A3853-JADIF', ''),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 3.5),
                    child: buildField('Professor: ', 'Fulano da Silva'),
                  ),
                  buildField('21 ', 'participantes'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
