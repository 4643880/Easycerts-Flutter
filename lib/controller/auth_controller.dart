import 'dart:io';

import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'dart:developer' as devtools show log;
import '../helper/hive_boxes.dart';
import '../model/user_model.dart';
import '../repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  RxBool isLoading = true.obs;
  RxBool isLogin = false.obs;
  RxString token = "".obs;
  Rx<UserModel> userModel = UserModel().obs;

  Future<bool> saveToken() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    String deviceType = Platform.isAndroid ? "android" : "ios";
    String? fcm = await FirebaseMessaging.instance.getToken();
    try {
      dynamic check = await AuthRepo().saveToken(
        fcm,
        deviceId,
        deviceType,
      );
      if (check != null) {
        if (check['data'] != null) {
          devtools.log(check['data']['created_at']);
          devtools.log("FCM => " + check['data']['device_token']);
          devtools.log("FCM posted Successfully ....");
          update();
          return true;
        } else {
          devtools.log("Not Posted FCM");
          Util.showErrorSnackBar(check['status_code'].toString());
        }
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in saveTokenApi = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> loginWithApi(String email, String password) async {
    try {
      dynamic check = await AuthRepo().loginWithApi(email, password);
      if (check != null) {
        UserModel tempUserModel = UserModel.fromJson(check['data']);
        token.value = check['token'];
        await loginAsUser(tempUserModel, check['token']);
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in loginWithApi = $e");
      }
      update();
      return false;
    }
  }

  Future<void> loginAsUser(
    UserModel userModel,
    String tempToken,
  ) async {
    await saveLoginUserInHive(userModel, tempToken);

    isLogin.value = true;

    updateLocalValues(userModel, tempToken);
    update();
  }

  updateLocalValues(
    UserModel userModel,
    String tempToken,
  ) {
    token.value = tempToken;
    changeUserModel(userModel);
  }

  Future<void> saveLoginUserInHive(
    UserModel userModel,
    String tempToken,
  ) async {
    final userModelBox = Boxes.getUserModel();
    final isLoginBox = Boxes.getIsLogin();
    final tokenBox = Boxes.getToken();

    await userModelBox.put(AppTexts.hiveUserModel, userModel);
    await isLoginBox.put(AppTexts.hiveIsLogin, true);
    await tokenBox.put(AppTexts.hiveToken, tempToken);
  }

  Future<void> logoutLocally() async {
    final userModelBox = Boxes.getUserModel();
    final isLoginBox = Boxes.getIsLogin();
    final tokenBox = Boxes.getToken();

    await userModelBox.put(AppTexts.hiveUserModel, UserModel());
    await isLoginBox.put(AppTexts.hiveIsLogin, false);
    await tokenBox.put(AppTexts.hiveToken, "");

    isLogin.value = false;
    token.value = "";
    changeUserModel(UserModel());
  }

  void changeUserModel(UserModel tempUserModel) {
    userModel.value = tempUserModel;
    update();
  }

  void changeIsLogin(bool value) {
    isLogin.value = value;
    update();
  }

  void changeToken(String value) {
    token.value = value;
    update();
  }

  updateIsLoading(bool value) {
    isLoading.value = value;
    update();
  }
}
