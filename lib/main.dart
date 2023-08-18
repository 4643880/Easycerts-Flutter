import 'dart:convert';

import 'package:easy_certs/firebase_options.dart';
import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/helper/fcm.dart';
import 'package:easy_certs/theme/themes.dart';
import 'package:easy_certs/utils/extra_function.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:developer' as devtools show log;
import 'config/routes.dart';
import 'helper/get_di.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await onBgNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).whenComplete(() {
    devtools.log("Firebase Initialized Successfully");
  });
  await init();
  // Push Notifications Initialization
  await checkPermissions();
  await initAndroidForegroundFcm();
  await enableIOSForeground();
  await requestDeviceFcmPermissions();
  await initInfo();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getPermission();
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: ScreenUtilInit(
        builder: ((context, child) {
          final easyLoading = EasyLoading.init();
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Easy Carts",
            builder: (context, child) {
              ScreenUtil.init(
                context,
                designSize: const Size(360, 800),
              );
              child = easyLoading(context, child);
              Util.setEasyLoading();
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child,
              );
            },
            theme: kAppTheme,
            getPages: Routes.routes,
            initialRoute: routeSplash,
            defaultTransition: Transition.native,
            transitionDuration: const Duration(milliseconds: 300),
            // initialRoute: AddPetsScreen.routeName,
          );
        }),
      ),
    );
  }
}
