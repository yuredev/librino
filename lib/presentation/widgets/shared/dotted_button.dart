import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';

class DottedButton extends StatelessWidget {
  final String title;

  final EdgeInsets padding;
  final Widget? icon;
  final Color borderColor;
  final Color titleColor;
  final void Function() onPress;
  final double borderRadius;

  const DottedButton({
    super.key,
    this.titleColor = LibrinoColors.grayPlaceholder,
    required this.title,
    this.borderColor = LibrinoColors.grayInputBorder,
    this.borderRadius = Sizes.defaultInputBorderRadius,
    this.padding = const EdgeInsets.symmetric(vertical: 22),
    required this.onPress,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onTap: onPress,
      borderRadius: borderRadius,
      child: DottedBorder(
        color: borderColor,
        strokeWidth: 1.2,
        dashPattern: [2.5, 2],
        radius: Radius.circular(borderRadius),
        borderType: BorderType.RRect,
        child: Container(
          width: double.infinity,
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon!,
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
