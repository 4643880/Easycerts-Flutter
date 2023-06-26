import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/theme/themes.dart';
import 'package:easy_certs/utils/extra_function.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:developer' as devtools show log;

import 'config/routes.dart';
import 'helper/get_di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

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
