import 'package:flutter/material.dart';

class LoadingLayout extends StatefulWidget {
  final Widget childWidget;
  bool isLoading = false;
  LoadingLayout(
      {super.key, required this.childWidget, required this.isLoading});

  @override
  State<LoadingLayout> createState() => _LoadingLayoutState();
}

class _LoadingLayoutState extends State<LoadingLayout> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.childWidget,
        if (widget.isLoading)
          Container(
            color: Colors.black.withOpacity(0.15),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
