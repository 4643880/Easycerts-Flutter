import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../helper/api.dart';
import 'dart:developer' as devtools show log;

class NotificationRepo {
  Future<dynamic> get() async {
    AuthController authController = Get.find();
    dynamic dynamicData = await ApiHelper().get(
        "notifications",
        ApiHelper.getApiUrls()[ApiHelper.kGetNotifications]!,
        authController.isLogin.value
            ? {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer ${authController.token.value}"
              }
            : null);
    return dynamicData;
  }

  Future<dynamic> notificationReadMark(String id) async {
    AuthController authController = Get.find();
    Uri api = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kMarkNotificationAsRead]!.toString()}/$id/markAsRead");
    devtools.log(api.toString());
    dynamic dynamicData = await ApiHelper().get(
      "notificationReadMark",
      api,
      authController.isLogin.value
          ? {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer ${authController.token.value}"
            }
          : null,
    );
    // dynamic dynamicData = await ApiHelper().put(
    //   "notificationReadMark",
    //   api,
    //   authController.isLogin.value
    //       ? {
    //           "Content-Type": "application/json",
    //           "Accept": "application/json",
    //           "Authorization": "Bearer ${authController.token.value}"
    //         }
    //       : null,
    //   null,
    // );
    return dynamicData;
  }
}
