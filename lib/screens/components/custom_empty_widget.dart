import 'package:easy_certs/helper/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/text_styles.dart';

class CustomEmptyWidget extends StatelessWidget {
  CustomEmptyWidget({
    Key? key,
    required this.text,
    this.height,
  }) : super(key: key);
  String text;
  double? height;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: height ?? 320.h,
        ),
        Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: kTextStyle12Normal.copyWith(color: AppColors.grey),
          ),
        ),
      ],
    );
  }
}
