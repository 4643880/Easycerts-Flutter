import 'dart:async';

import '../helper/api.dart';

class AuthRepo {
  Future<dynamic> loginWithApi(String email, String password) async {
    dynamic dynamicData = await ApiHelper().post(
        "login",
        ApiHelper.getApiUrls()[ApiHelper.kLogin]!,
        null,
        <String, dynamic>{"email": email, "password": password});
    return dynamicData;
  }

  Future<dynamic> saveToken(
    String? fcmToken,
    String? udid,
    String deviceType,
  ) async {
    Uri uri = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kSaveToken]!}?device_token=$fcmToken&type=$deviceType&udid=$udid");
    dynamic dynamicData = await ApiHelper().post(
      "saveToken", uri, ApiHelper.getAuthHeader(), {},
      // <String, dynamic>{
      //   "device_id": deviceId,
      //   "api_token": apiToken,
      //   "device_type": deviceType,
      //   "cookie": "",
      //   "user_id": userId
      // },
    );

    return dynamicData;
  }
}
