import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/firebase_constants.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/classes/select_class_modal.dart';
import 'package:librino/presentation/widgets/shared/gray_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:librino/presentation/widgets/shared/shimmer_widget.dart';

class ClassWidget extends StatelessWidget {
  final Color color;
  final Color textColor;
  final Color? iconColor;
  final bool disableSelection;
  final Class? clazz;
  final bool isLoading;
  final void Function() switchTabCallback;

  const ClassWidget({
    super.key,
    this.disableSelection = false,
    required this.color,
    required this.textColor,
    this.iconColor,
    this.clazz,
    this.isLoading = false,
    required this.switchTabCallback,
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
    final SelectClassCubit selectClassCubit = context.read();
    final conteudo = InkWellWidget(
      borderRadius: 24,
      onTap: () => PresentationUtils.showBottomModal(
        context,
        SelectClassModal(
          cubit: selectClassCubit,
          clazz: clazz!,
          switchTabCallback: switchTabCallback,
          disableSelecion: disableSelection,
        ),
      ),
      child: Stack(
        children: [
          if (clazz?.id == FirebaseConstants.defaultClassId)
            Positioned(
              right: 12,
              top: 23.5,
              child: Icon(
                Icons.verified_outlined,
                size: 50,
                color: iconColor?.withOpacity(0.07) ??
                    LibrinoColors.textLightBlack.withOpacity(0.07),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.school,
                    size: 45,
                    color: isLoading
                        ? null
                        : iconColor ??
                            LibrinoColors.textLightBlack.withOpacity(0.25),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 3.5),
                      child: isLoading
                          ? const GrayBarWidget(height: 17.5, width: 110)
                          : buildField(clazz?.name ?? '', ''),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 3.5),
                      child: isLoading
                          ? const GrayBarWidget(height: 17.5, width: 160)
                          : buildField(
                              'Instrutor: ',
                              clazz?.id == FirebaseConstants.defaultClassId
                                  ? 'Equipe Librino'
                                  : clazz?.ownerName ?? '--'),
                    ),
                    // TODO:
                    isLoading
                        ? const GrayBarWidget(height: 17.5, width: 110)
                        : buildField('', '21 participantes'),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: isLoading ? ShimmerWidget(child: conteudo) : conteudo,
    );
  }
}
