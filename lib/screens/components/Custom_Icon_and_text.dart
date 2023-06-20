import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helper/app_colors.dart';
import '../../theme/text_styles.dart';

class CustomIconAndText extends StatelessWidget {
  CustomIconAndText({
    Key? key,
    required this.iconData,
    required this.text,
  }) : super(key: key);

  IconData iconData;
  String? text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: AppColors.secondary,
          size: 20.h,
        ),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
          child: Text(
            text ?? "",
            style: kTextStyle11Normal.copyWith(color: AppColors.secondary),
          ),
        ),
      ],
    );
  }
}
