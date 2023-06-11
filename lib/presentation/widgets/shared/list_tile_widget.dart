import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/widgets/shared/gray_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/shimmer_widget.dart';

class ListTileWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final void Function()? onTap;
  final double fontSize;
  final bool isLoading;
  final double elevation;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;

  const ListTileWidget({
    super.key,
    this.isLoading = false,
    this.title,
    this.fontSize = 14,
    this.elevation = 1,
    this.subtitle,
    this.icon,
    this.contentPadding,
    this.onTap,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final content = ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: contentPadding,
      onTap: onTap,
      leading: icon == null
          ? null
          : Icon(
              icon,
              size: 28,
              color: LibrinoColors.iconGray,
            ),
      minLeadingWidth: 0,
      title: isLoading
          ? Row(
              children: [GrayBarWidget(height: 14, width: 225)],
            )
          : Text(
              title!,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: fontSize,
                color: LibrinoColors.textLightBlack,
              ),
            ),
      subtitle: Container(
        margin: const EdgeInsets.only(top: 4),
        child: isLoading
            ? Row(
                children: [GrayBarWidget(height: 14, width: 150)],
              )
            : subtitle == null
                ? null
                : Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: fontSize - 1,
                      color: LibrinoColors.subtitleGray,
                    ),
                  ),
      ),
    );
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      child: isLoading ? ShimmerWidget(child: content) : content,
    );
  }
}
