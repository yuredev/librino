import 'package:flutter/material.dart';

class InkWellWidget extends StatelessWidget {
  final double? borderRadius;
  final void Function()? onTap;
  final bool enableSplash;
  final Widget child;

  const InkWellWidget({
    super.key,
    this.borderRadius,
    required this.onTap,
    this.enableSplash = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius:
          borderRadius == null ? null : BorderRadius.circular(borderRadius!),
      color: Colors.transparent,
      child: Theme(
        data: ThemeData(
          splashColor: enableSplash ? null : Colors.transparent,
          highlightColor: enableSplash ? null : Colors.transparent,
        ),
        child: InkWell(
          borderRadius: borderRadius == null
              ? null
              : BorderRadius.circular(borderRadius!),
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
