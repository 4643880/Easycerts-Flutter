import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helper/app_colors.dart';
import 'large_button.dart';

class BottomSheetTwoButton extends StatelessWidget {
  BottomSheetTwoButton({
    Key? key,
    this.onPressed,
    this.onPressed2,
    required this.buttonTitle,
    required this.buttonTitle2,
    this.bgColor,
    this.textColor,
    this.borderColor,
    this.bgColor2,
    this.textColor2,
    this.borderColor2,
  }) : super(key: key);

  void Function()? onPressed, onPressed2;
  final String buttonTitle, buttonTitle2;
  Color? bgColor, textColor, borderColor, bgColor2, textColor2, borderColor2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.inputBorder, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomLargeButton(
            width: 155.w,
            maxLines: 2,
            bgColor: bgColor ?? AppColors.purple,
            textColor: textColor ?? AppColors.white,
            borderColor: borderColor ?? AppColors.primary,
            title: buttonTitle.toUpperCase(),
            onPressed: onPressed,
          ),
          CustomLargeButton(
            width: 155.w,
            maxLines: 2,
            bgColor: bgColor2 ?? AppColors.purple,
            textColor: textColor2 ?? AppColors.white,
            borderColor: borderColor2 ?? AppColors.primary,
            title: buttonTitle2.toUpperCase(),
            onPressed: onPressed2,
          ),
        ],
      ),
    );
  }
}
