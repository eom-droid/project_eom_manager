import 'package:flutter/material.dart';
import 'package:manager/common/const/colors.dart';

class CustomAnimatedSwitch extends StatefulWidget {
  final bool value;
  final void Function(bool) onChanged;

  const CustomAnimatedSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomAnimatedSwitch> createState() => _CustomAnimatedSwitchState();
}

class _CustomAnimatedSwitchState extends State<CustomAnimatedSwitch>
    with AutomaticKeepAliveClientMixin {
  // final animationDuration = const Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.onChanged(!widget.value);
          },
          child: Container(
            // duration: animationDuration,
            height: 30,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: widget.value ? PRIMARY_COLOR : BODY_TEXT_COLOR,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Align(
              // duration: animationDuration,
              alignment:
                  widget.value ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
