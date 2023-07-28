import 'package:flutter/material.dart';
import 'package:manager/common/const/colors.dart';

class DefaultSliverAppbarListviewLayout extends StatelessWidget {
  final Widget sliverAppBar;
  final Future<void> onRefresh;
  final VoidCallback onPressAdd;
  final Widget listview;
  const DefaultSliverAppbarListviewLayout({
    super.key,
    required this.sliverAppBar,
    required this.onRefresh,
    required this.onPressAdd,
    required this.listview,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_BLACK,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              sliverAppBar,
            ],
            body: RefreshIndicator(
              onRefresh: () async {
                onRefresh;
              },
              child: listview,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: onPressAdd,
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
