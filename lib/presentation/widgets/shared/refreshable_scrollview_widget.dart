import 'package:flutter/material.dart';

class RefreshableScrollViewWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final EdgeInsets? padding;

  const RefreshableScrollViewWidget({
    Key? key,
    required this.onRefresh,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          padding: padding,
          physics: const AlwaysScrollableScrollPhysics(),
          child: child,
        ),
      ),
    );
  }
}
