import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/common/layout/default_layout.dart';

class SplashScreen extends ConsumerWidget {
  static String get routeName => '/splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
