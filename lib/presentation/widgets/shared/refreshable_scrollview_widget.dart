import 'package:flutter/material.dart';

class RefreshableScrollViewWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const RefreshableScrollViewWidget({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: child,
        ),
      ),
    );
  }
}

