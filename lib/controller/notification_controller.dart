import 'package:easy_certs/controller/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../model/notification_model.dart';
import '../repository/notification_repo.dart';
import '../utils/util.dart';
import 'dart:developer' as devtools show log;

class NotificationController extends GetxController implements GetxService {
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool fromNotificationScreen = false.obs;

  Future<bool> get() async {
    try {
      dynamic check = await NotificationRepo().get();
      if (check != null) {
        List<dynamic> tempNotificationList = check['data'];
        // devtools.log(tempNotificationList.toString());
        notificationList.value = tempNotificationList
            .map((e) => NotificationModel.fromJson(e))
            .toList();
        update();
        return true;
      } else {
        Util.showErrorSnackBar(check['message']);
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in getNotification = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> notificationReadMark(String id) async {
    try {
      dynamic check = await NotificationRepo().notificationReadMark(id);
      if (check != null) {
        var temp = check['data']['status'];
        if (temp == 'read') {
          update();
          return true;
        }
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in notificationReadMark = $e");
      }
      update();
      return false;
    }
  }

  updateNotificationList(int index) {
    notificationList[index] = notificationList[index].copyWith(status: "read");
    update();
  }

  updateIsLoading(bool value) {
    isLoading.value = value;
    update();
  }
}
