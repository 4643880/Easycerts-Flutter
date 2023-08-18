import 'package:easy_certs/controller/notes_controller.dart';
import 'package:easy_certs/controller/splash_controller.dart';
import 'package:easy_certs/controller/timeToReachSite_controller.dart';
import 'package:easy_certs/controller/workTime_controller.dart';
import 'package:easy_certs/model/timer_model.dart';
import 'package:easy_certs/model/worksheet_data_submit_model.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../controller/auth_controller.dart';
import '../controller/dashboard_controller.dart';
import '../controller/job_controller.dart';
import '../controller/notification_controller.dart';
import '../model/user_model.dart';
import 'app_texts.dart';

Future<void> init() async {
  // Controller
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => DashboardController());
  Get.lazyPut(() => NotificationController());
  Get.lazyPut(() => JobController());
  Get.lazyPut(() => NotesController());

  await Hive.initFlutter();

  Hive.registerAdapter<UserModel>(UserModelAdapter());
  Hive.registerAdapter<Engineer>(EngineerAdapter());
  Hive.registerAdapter<WorksheetDataSubmitModel>(
      WorksheetDataSubmitModelAdapter());

  await Hive.openBox<UserModel>(AppTexts.hiveUserModel);
  await Hive.openBox(AppTexts.hiveIsLogin);
  await Hive.openBox(AppTexts.hiveToken);
  await Hive.openBox(AppTexts.hiveCurrentWorkingUrl);
  await Hive.openBox(AppTexts.hiveWorkSpaceDataBoxName);
  await Hive.openBox(AppTexts.hiveKeyOfWorkSpaceData);
  await Hive.openBox(AppTexts.hiveKeyOfSubmittedWorkSpaceData);
  await Hive.openBox(AppTexts.hiveWorkSpaceSubmittedDataBoxName);

  // Controller will be here
  Get.lazyPut(
    () => TimeToReachSiteController(),
  );
  Get.lazyPut(
    () => WorkTimeController(),
  );

  Hive.registerAdapter<TimerModel>(TimerModelAdapter());
  await Hive.openBox<TimerModel>(AppTexts.hiveTimer);
  await Hive.openBox<TimerModel>(AppTexts.hiveWorkTime);

  FlutterNativeSplash.remove();
}
