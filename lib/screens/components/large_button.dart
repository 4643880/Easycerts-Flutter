import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class CustomLargeButton extends StatelessWidget {
  const CustomLargeButton({
    Key? key,
    required this.title,
    this.onPressed,
    required this.bgColor,
    required this.textColor,
    this.width,
    this.height,
    this.borderColor,
    this.maxLines,
  }) : super(key: key);

  final String title;
  final double? width, height;

  final void Function()? onPressed;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius4),
        ),
        onTap: onPressed,
        child: Ink(
          height: height ?? 44.h,
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(kBorderRadius4),
            border: Border.all(
                color: borderColor != null ? borderColor! : bgColor, width: 1),
          ),
          child: Center(
            child: Text(
              title,
              maxLines: maxLines ?? 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: textColor,
                letterSpacing: 1,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
