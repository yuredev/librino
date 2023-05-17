import 'package:flutter/material.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:librino/presentation/widgets/shared/refreshable_scrollview_widget.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen();

  @override
  Widget build(BuildContext context) {
    return LibrinoScaffold(
      body: RefreshableScrollViewWidget(
        onRefresh: () async {},
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
