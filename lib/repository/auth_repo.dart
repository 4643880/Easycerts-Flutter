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
}
