import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'custom_shimmer.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool displayLeading, isLoading;
  final VoidCallback? leadingOnTap;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor, foregroundColor;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  CustomAppbar({
    Key? key,
    this.displayLeading = false,
    this.isLoading = false,
    required this.title,
    this.bottom,
    this.action,
    this.centerTitle,
    this.leadingOnTap,
    this.backgroundColor,
    this.foregroundColor,
    this.systemUiOverlayStyle,
  }) : super(key: key);
  List<Widget>? action;
  bool? centerTitle;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: action ?? [],
      backgroundColor: isLoading
          ? Colors.grey.shade50
          : backgroundColor ?? AppColors.primary,
      foregroundColor: AppColors.black,
      elevation: 0.3,
      centerTitle: centerTitle ?? true,
      title: isLoading
          ? CustomShimmer(
              height: 20.h,
              width: 140.w,
            )
          : Text(
              title,
              style: kTextStyle16Normal.copyWith(
                color: foregroundColor ?? AppColors.white,
              ),
            ),
      titleSpacing: 0,
      systemOverlayStyle: systemUiOverlayStyle ??
          const SystemUiOverlayStyle(
            statusBarColor: AppColors.primary,
            statusBarIconBrightness: Brightness.light,
          ),
      bottom: bottom,
      leadingWidth: displayLeading == false ? 24.w : null,
      leading: displayLeading
          ? isLoading
              ? Center(
                  child: CustomShimmer(
                    height: 20.h,
                    width: 20.h,
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: foregroundColor ?? AppColors.white,
                  ),
                  onPressed: leadingOnTap ??
                      () {
                        Get.back();
                      },
                )
          : const SizedBox(),
    );
  }

  double _getHeight() {
    return bottom == null ? kToolbarHeight : kToolbarHeight + kTextTabBarHeight;
  }

  @override
  Size get preferredSize => Size.fromHeight(_getHeight());
}
