import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants.dart';
import '../../helper/app_colors.dart';

class CustomShimmer extends StatelessWidget {
  CustomShimmer(
      {Key? key,
      required this.height,
      required this.width,
      this.borderRadiusValue,
      this.boxDecoration,
      this.baseColor,
      this.highlightColor})
      : super(key: key);
  double height, width;
  double? borderRadiusValue;
  BoxDecoration? boxDecoration;
  Color? baseColor, highlightColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: baseColor ?? AppColors.shimmer1,
        highlightColor: highlightColor ?? AppColors.shimmer2,
        child: Container(
          width: width,
          height: height,
          decoration: boxDecoration ??
              BoxDecoration(
                color: AppColors.shimmer1,
                borderRadius:
                    BorderRadius.circular(borderRadiusValue ?? kBorderRadius8),
              ),
        ),
      ),
    );
  }
}
