import 'package:easy_certs/helper/app_texts.dart';
import 'package:get/get.dart';

import '../helper/hive_boxes.dart';
import '../model/user_model.dart';
import 'auth_controller.dart';

class SplashController extends GetxController {
  Future<bool> userIsLogin() async {
    //Getting Values from Hive DB
    final userModelBox = Boxes.getUserModel();
    final tokenBox = Boxes.getToken();

    UserModel? userModel = userModelBox.get(AppTexts.hiveUserModel);
    String? token = tokenBox.get(AppTexts.hiveToken);

    // await sendUserFcmAndDeviceToken(token ?? "");

    //Setting Values in AuthController
    AuthController authController = Get.find();
    authController.changeUserModel(userModel ?? UserModel());
    authController.changeIsLogin(true);
    authController.changeToken(token ?? "");

    // bool temp = await authController.getUserLatestInformation();
    // if (temp == false) {
    //   authController.changeUserModel(userModel ?? UserModel());
    // }

    return true;
  }

  bool userIsNotLogin() {
    //Setting Values in AuthController
    AuthController authController = Get.find();
    authController.changeUserModel(UserModel());
    authController.changeIsLogin(false);
    authController.changeToken("");

    return true;
  }
}

// Future<bool> sendUserFcmAndDeviceToken(String token) async {
//   // String deviceToken = await getDeviceIdentifier();
//   String? deviceToken = await PlatformDeviceId.getDeviceId;
//
//   String? fcm = await FirebaseMessaging.instance.getToken();
//   String platform = Platform.isAndroid ? "android" : "ios";
//
//   if (fcm != null) {
//     try {
//       dynamic check = await SplashRepo()
//           .fcmAndDeviceToken(fcm, deviceToken ?? "", platform, token);
//       var temp = check["status"];
//       if (temp["success"] as bool) {
//         return true;
//       }
//       return false;
//     } catch (e) {
//       print("Exception from FCM-Token-API  = $e");
//       return false;
//     }
//   }
//   return false;
// }
