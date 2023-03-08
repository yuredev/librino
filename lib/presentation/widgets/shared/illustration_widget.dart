import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:lottie/lottie.dart';

class IllustrationWidget extends StatelessWidget {
  final String illustrationName;
  final String title;
  final String? subtitle;
  final bool titleOnTop;
  final double? imageWidth;
  final double? imageHeight;
  final bool centered;
  final TextAlign? titleAlignment;
  final TextAlign? subtitleAlignment;
  final bool isAnimation;
  final double textImageSpacing;
  final double fontSize;
  final bool boldTitle;
  final Color? titleColor;

  const IllustrationWidget({
    Key? key,
    required this.illustrationName,
    required this.title,
    this.centered = true,
    this.fontSize = 15.5,
    this.titleOnTop = false,
    this.textImageSpacing = 16,
    this.isAnimation = false,
    this.titleColor,
    this.boldTitle = false,
    this.subtitle,
    this.imageWidth,
    this.imageHeight,
    this.titleAlignment = TextAlign.center,
    this.subtitleAlignment = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = [
      isAnimation
          ? Lottie.asset(
              'assets/animations/$illustrationName',
              width: imageWidth,
              height: imageHeight,
            )
          : Image.asset(
              'assets/images/$illustrationName',
              width: imageWidth,
              height: imageHeight,
            ),
      SizedBox(height: textImageSpacing),
      SizedBox(
        width: 250,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              child: Text(
                title,
                textAlign: titleAlignment,
                style: TextStyle(
                  color: titleColor,
                  fontSize: fontSize,
                  fontWeight: boldTitle ? FontWeight.bold : null,
                ),
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                textAlign: subtitleAlignment,
                style: TextStyle(
                  fontSize: fontSize - 3.5,
                  color: LibrinoColors.subtitleGray,
                ),
              ),
          ],
        ),
      ),
    ];

    return Align(
      alignment: centered ? Alignment.center : Alignment.topLeft,
      child: Column(
        children: titleOnTop ? content.reversed.toList() : content,
      ),
    );
  }
}
