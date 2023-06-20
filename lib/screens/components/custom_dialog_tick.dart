import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helper/app_colors.dart';

class CustomDialogTick extends StatelessWidget {
  const CustomDialogTick({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 80.w,
        backgroundColor: AppColors.yellow,
        child: Icon(
          Icons.check,
          color: AppColors.white,
          size: 80.w,
        ),
      ),
    );
  }
}
