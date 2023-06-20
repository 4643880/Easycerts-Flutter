import 'package:flutter/material.dart';

class CustomAnimateSwitcher extends StatelessWidget {
  CustomAnimateSwitcher({Key? key, required this.child}) : super(key: key);
  Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeInExpo,
      switchOutCurve: Curves.easeInExpo,
      child: child,
    );
  }
}
