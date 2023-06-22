import 'package:easy_certs/config/routes.dart';
import 'package:easy_certs/controller/splash_controller.dart';
import 'package:easy_certs/helper/app_assets.dart';
import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';
import '../../helper/api.dart';
import '../../helper/hive_boxes.dart';
import '../../utils/extra_function.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Future.delayed(const Duration(seconds: 1), () async {
          final currentWorkingUrlBox = Boxes.getCurrentWorkingUrl();
          String? checkCurrentWorkingUrl =
              currentWorkingUrlBox.get(AppTexts.hiveCurrentWorkingUrl);
          if (checkCurrentWorkingUrl == null) {
            checkCurrentWorkingUrl = kLiveBaseUrl;
            await currentWorkingUrlBox.put(
                AppTexts.hiveCurrentWorkingUrl, kLiveBaseUrl);
            ApiHelper.baseUrl = kLiveBaseUrl;
          } else {
            ApiHelper.baseUrl = checkCurrentWorkingUrl;
          }
          final box = Boxes.getIsLogin();
          bool? isLogin = box.get(AppTexts.hiveIsLogin);
          if (isLogin != null && isLogin == true) {
            SplashController splashController = Get.find();
            bool navCheck = await splashController.userIsLogin();
            if (navCheck) {
              // if (await ApiHelper().internetAvailabilityCheck()) {
              Get.offNamed(routeDashboard);

              if (Get.context != null) {
                await checkVersion(Get.context!);
              }
              // }
              // else {
              //   Get.offAllNamed(routeInternetNotAvailable);
              // }
            }
          } else {
            Get.offNamed(routeLogin);
            if (Get.context != null) {
              await checkVersion(Get.context!);
            }
          }
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primary,
        child: Center(
          child: Image.asset(
            AppAssets.logoImg,
          ),
        ),
      ),
    );
  }
}
