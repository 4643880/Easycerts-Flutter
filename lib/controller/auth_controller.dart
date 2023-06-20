import 'package:easy_certs/helper/app_texts.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../helper/hive_boxes.dart';
import '../model/user_model.dart';
import '../repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  RxBool isLoading = true.obs;
  RxBool isLogin = false.obs;
  RxString token = "".obs;
  Rx<UserModel> userModel = UserModel().obs;

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
