import 'package:easy_certs/config/routes.dart';
import 'package:easy_certs/constants.dart';
import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/dashboard_controller.dart';
import 'package:easy_certs/helper/app_assets.dart';
import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/screens/components/custom_app_bar.dart';
import 'package:easy_certs/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/extra_function.dart';
import '../../utils/util.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        appBar: CustomAppbar(
          title: AppTexts.profile,
          centerTitle: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: kBorderRadius40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kBorderRadius50),
                      child: Image.asset(AppAssets.logoImg),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        authController.userModel.value.name ?? "",
                        style: kTextStyle18Bold,
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(authController.userModel.value.email ?? ""),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 14.h,
              ),
              Divider(
                color: AppColors.grey300,
                thickness: 1.h,
              ),
              InkWell(
                onTap: () {
                  customDialog(
                    context: context,
                    barrierDismissible: false,
                    titleText: AppTexts.loggingOut,
                    middleText: AppTexts.logoutConformation,
                    afterTextWidget: null,
                    buttonLeftText: AppTexts.cancel,
                    buttonLeftTextOnTap: () {
                      Get.back(closeOverlays: true);
                    },
                    buttonRightText: AppTexts.logout,
                    buttonRightTextOnTap: () async {
                      Get.back(closeOverlays: true);
                      Util.showLoading(AppTexts.loggingOut);
                      await authController.logoutLocally().then((value) {
                        Future.delayed(const Duration(seconds: 1), () {
                          Util.dismiss();
                          Get.offAllNamed(routeLogin);
                          Future.delayed(const Duration(seconds: 1), () {
                            DashboardController dashboardController =
                                Get.find();
                            dashboardController.updateCurrentIndex(0);
                          });
                        });
                      });
                    },
                  );
                },
                borderRadius: BorderRadius.circular(kBorderRadius4),
                splashColor: AppColors.red.withOpacity(0.2),
                child: Ink(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
                  child: Text(
                    AppTexts.logout,
                    style: kTextStyle12Normal.copyWith(
                      color: AppColors.red,
                    ),
                  ),
                ),
              ),
              Divider(
                color: AppColors.grey300,
                thickness: 1.h,
              ),
            ],
          ),
        ),
      );
    });
  }
}
