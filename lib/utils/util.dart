import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../helper/app_colors.dart';
import '../theme/text_styles.dart';

class Util {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static void showToast(String message) {
    EasyLoading.showToast(
      message,
      duration: const Duration(seconds: 3),
      toastPosition: EasyLoadingToastPosition.bottom,
      dismissOnTap: true,
      maskType: EasyLoadingMaskType.clear,
    );
  }

  static void showLoading(String message) {
    EasyLoading.show(
      status: message,
      indicator: const CircularProgressIndicator.adaptive(),
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
    );
  }

  static void showSnackBar(String title, String message, String? svgPicture) {
    Get.snackbar(title, message);
  }

  static void showErrorSnackBar(String message) {
    Get.snackbar(
      "",
      "",
      titleText: Text(
        "Error",
        maxLines: 1,
        style: kTextStyle16Normal.copyWith(color: AppColors.red),
      ),
      messageText: Text(
        message,
        maxLines: 3,
        style: kTextStyle12Normal,
      ),
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
      backgroundColor: AppColors.grey300,
    );
  }

  static void setEasyLoading() {
    EasyLoading.instance
      ..indicatorSize = 22.w
      ..indicatorType = EasyLoadingIndicatorType.foldingCube
      ..userInteractions = false
      ..dismissOnTap = false
      ..backgroundColor = Colors.black.withOpacity(0.5)
      ..animationStyle = EasyLoadingAnimationStyle.opacity
      ..animationDuration = const Duration(milliseconds: 400);
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}
