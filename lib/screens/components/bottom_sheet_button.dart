import 'package:easy_certs/helper/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'large_button.dart';

class BottomSheetButton extends StatelessWidget {
  BottomSheetButton({
    Key? key,
    this.onPressed,
    required this.buttonTitle,
    this.bgColor,
    this.textColor,
    this.borderColor,
  }) : super(key: key);

  void Function()? onPressed;
  final String buttonTitle;
  Color? bgColor, textColor, borderColor;

  get kBottomSheetHeight => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      height: kBottomSheetHeight,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.inputBorder, width: 0.5),
        ),
      ),
      child: CustomLargeButton(
        height: 40.h,
        bgColor: bgColor ?? AppColors.purple,
        textColor: textColor ?? AppColors.white,
        borderColor: borderColor ?? AppColors.primary,
        title: buttonTitle.toUpperCase(),
        onPressed: onPressed,
      ),
    );
  }
}
