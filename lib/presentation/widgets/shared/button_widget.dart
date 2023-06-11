import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:librino/core/constants/colors.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final double borderRadius;
  final Color color;
  final Color? borderColor;
  final double? borderWidth;
  final Color textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double? iconTitleSpacing;
  final double? elevation;
  final String? loadingText;
  final bool isLoading;
  final EdgeInsets? titleMargin;
  final bool isEnabled;

  const ButtonWidget({
    Key? key,
    this.onPress,
    required this.title,
    this.isEnabled = true,
    this.color = LibrinoColors.main,
    this.textColor = Colors.white,
    this.titleMargin,
    this.fontSize,
    this.leftIcon,
    this.rightIcon,
    this.fontWeight,
    this.padding,
    this.width,
    this.iconTitleSpacing,
    this.elevation,
    this.height,
    this.loadingText,
    this.isLoading = false,
    this.borderRadius = 5,
    this.borderColor,
    this.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final estiloFonte = GoogleFonts.roboto(
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: onPress == null ? Colors.white : textColor,
    );
    Widget child;
    if (isLoading) {
      child = loadingText != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(child: CircularProgressIndicator(color: textColor)),
                const SizedBox(width: 8),
                Container(
                  margin: titleMargin,
                  child: Text(
                    loadingText!,
                    style: estiloFonte,
                  ),
                ),
              ],
            )
          : FittedBox(child: CircularProgressIndicator(color: textColor));
    } else if (leftIcon == null) {
      child = Text(title, style: estiloFonte);
    } else {
      child = FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null) leftIcon!,
            if (leftIcon != null) SizedBox(width: iconTitleSpacing ?? 6),
            Container(
              margin: titleMargin,
              child: Text(
                title,
                style: estiloFonte,
              ),
            ),
            if (rightIcon != null) SizedBox(width: iconTitleSpacing ?? 6),
            if (rightIcon != null) rightIcon!,
          ],
        ),
      );
    }
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: isEnabled && onPress != null
            ? () {
                if (isLoading) return;
                onPress!();
              }
            : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(0, 0),
          elevation: elevation,
          padding: padding,
          backgroundColor: color,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null || borderWidth == 0
                ? BorderSide(
                    color: borderColor ?? Colors.black,
                    width: borderWidth ?? 1,
                  )
                : BorderSide.none,
          ),
        ),
        child: child,
      ),
    );
  }
}
