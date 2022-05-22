import 'package:flutter/material.dart';
import 'package:librino/core/app_routes.dart';

class LibrinoApp extends StatelessWidget {
  const LibrinoApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppRoutes.all,
    );
  }
}