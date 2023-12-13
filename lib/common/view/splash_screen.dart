import 'package:flutter/material.dart';
import 'package:manager/common/layout/default_layout.dart';

class SplashScreen extends StatelessWidget {
  static String get routeName => 'splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      isFullScreen: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('SplashScreen'),
        ],
      ),
    );
  }
}
