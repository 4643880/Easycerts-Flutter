import 'dart:async';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/helper/hive_boxes.dart';
import 'package:easy_certs/model/timer_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'dart:developer' as devtools show log;

class WorkTimeController extends GetxController {
  Timer? countdownTimer;
  Rx<Duration> myDuration = const Duration(seconds: 0).obs;

  Future<void> saveStartJobVisit({Duration? duration}) async {
    final id = Get.find<JobController>().selectedJob["id"].toString();
    if (duration != null) {
      final data =
          TimerModel(id: id, startTime: DateTime.now().subtract(duration));
      final box =
          await Boxes.getWorkTimeModelBox().put(AppTexts.hiveWorkTime, data);
      await data.save();
    } else {
      final data = TimerModel(id: id, startTime: DateTime.now());
      final box =
          await Boxes.getWorkTimeModelBox().put(AppTexts.hiveWorkTime, data);
      await data.save();
    }

    // devtools.log(box.toString());
    devtools.log("Saved Successfully");
  }

  Future<void> savePauseJobVisit() async {
    final id = Get.find<JobController>().selectedJob["id"].toString();
    final olddata = Boxes.getWorkTimeModelBox().get(AppTexts.hiveWorkTime);
    if (olddata != null) {
      final data = TimerModel(
          id: id, startTime: olddata.startTime, pauseTime: DateTime.now());
      final box =
          await Boxes.getWorkTimeModelBox().put(AppTexts.hiveWorkTime, data);
      await data.save();
      // devtools.log(box.toString());
      devtools.log("Saved Successfully");
    }
  }

  Future<void> saveCompleteJobVisitTime() async {
    final id = Get.find<JobController>().selectedJob["id"].toString();
    final olddata = Boxes.getWorkTimeModelBox().get(AppTexts.hiveWorkTime);
    final data = TimerModel(
        id: id, startTime: olddata?.startTime, endTime: DateTime.now());
    final box =
        await Boxes.getWorkTimeModelBox().put(AppTexts.hiveWorkTime, data);
    await data.save();
    // devtools.log(box.toString());
    devtools.log("Saved Successfully");
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    countdownTimer?.cancel();
    update();
  }

  void resetTimer() {
    stopTimer();
    myDuration.value = const Duration(seconds: 0);
    update();
  }

  void setCountDown() {
    const increaseSecondsBy = 1;
    final seconds = myDuration.value.inSeconds + increaseSecondsBy;
    if (seconds < 0) {
      countdownTimer!.cancel();
    } else {
      myDuration.value = Duration(seconds: seconds);
    }
    update();
  }
}
