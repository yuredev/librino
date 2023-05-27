import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';

class LibrinoScaffold extends StatelessWidget {
  final Color statusBarColor;
  final Color backgroundColor;
  final Widget body;
  final Widget? rightDrawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;

  const LibrinoScaffold({
    Key? key,
    required this.body,
    this.statusBarColor = LibrinoColors.grayStatusBar,
    this.rightDrawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor = LibrinoColors.backgroundWhite,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: backgroundColor,
      appBar: _VoidAppBarWidget(statusBarColor: statusBarColor),
      body: body,
      endDrawer: rightDrawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}

class _VoidAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Color statusBarColor;

  const _VoidAppBarWidget({
    Key? key,
    required this.statusBarColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: statusBarColor);
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
