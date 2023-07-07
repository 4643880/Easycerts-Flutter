import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/model/timer_model.dart';
import 'package:easy_certs/model/worksheet_data_submit_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/user_model.dart';

class Boxes {
  static Box<UserModel> getUserModel() =>
      Hive.box<UserModel>(AppTexts.hiveUserModel);
  static Box getIsLogin() => Hive.box(AppTexts.hiveIsLogin);
  static Box getToken() => Hive.box(AppTexts.hiveToken);
  //Current Working Base Url
  static Box getCurrentWorkingUrl() => Hive.box(AppTexts.hiveCurrentWorkingUrl);
  static Box getSavedWorkSpaceData() =>
      Hive.box(AppTexts.hiveWorkSpaceDataBoxName);
  static Box getKeysOfWorkSpaceData() =>
      Hive.box(AppTexts.hiveKeyOfWorkSpaceData);

  static Box<TimerModel> getTimerModelBox() =>
      Hive.box<TimerModel>(AppTexts.hiveTimer);
  static Box<TimerModel> getWorkTimeModelBox() =>
      Hive.box<TimerModel>(AppTexts.hiveTimer);
}
