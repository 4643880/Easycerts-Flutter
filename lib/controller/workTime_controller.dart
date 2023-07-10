import 'dart:async';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/helper/hive_boxes.dart';
import 'package:easy_certs/model/timer_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'dart:developer' as devtools show log;

class WorkTimeController extends GetxController {
  Timer? countdownTimer1;
  Rx<Duration> myDuration = const Duration(seconds: 0).obs;

  Future<void> saveStartJobVisit({Duration? duration}) async {
    final id = Get.find<JobController>().selectedJob["id"].toString();
    Future<void> delete(TimerModel model) async {
      model.delete();
    }

    if (duration != null) {
      final data =
          TimerModel(id: id, startTime: DateTime.now().subtract(duration));

      List<TimerModel> olddataList =
          Boxes.getWorkTimeModelBox().values.toList();
      TimerModel? olddata;
      olddataList.forEach((element) {
        if (element.id == id) {
          olddata = element;
          delete(element);
          update();
        }
      });

      final box = await Boxes.getWorkTimeModelBox().add(data);
      await data.save();
    } else {
      final data = TimerModel(id: id, startTime: DateTime.now());
      final box = await Boxes.getWorkTimeModelBox().add(data);
      await data.save();
    }

    // devtools.log(box.toString());
    devtools.log("Saved Successfully");
  }

  Future<void> savePauseJobVisit() async {
    Future<void> delete(TimerModel model) async {
      model.delete();
    }

    final id = Get.find<JobController>().selectedJob["id"].toString();
    List<TimerModel> olddataList = Boxes.getWorkTimeModelBox().values.toList();
    TimerModel? olddata;
    olddataList.forEach((element) {
      if (element.id == id) {
        olddata = element;
        delete(element);
        update();
      }
    });

    if (olddata != null) {
      final data = TimerModel(
        id: id,
        startTime: olddata?.startTime,
        pauseTime: DateTime.now(),
      );
      final box = await Boxes.getWorkTimeModelBox().add(data);
      await data.save();
      // devtools.log(box.toString());
      devtools.log("Saved Successfully");
    }
  }

  Future<void> saveCompleteJobVisitTime() async {
    Future<void> delete(TimerModel model) async {
      model.delete();
    }

    final id = Get.find<JobController>().selectedJob["id"].toString();
    List<TimerModel> olddataList = Boxes.getWorkTimeModelBox().values.toList();
    TimerModel? olddata;
    olddataList.forEach((element) {
      if (element.id == id) {
        olddata = element;
        delete(element);
        update();
      }
    });

    final data = TimerModel(
        id: id, startTime: olddata?.startTime, endTime: DateTime.now());
    final box = await Boxes.getWorkTimeModelBox().add(data);
    await data.save();
    // devtools.log(box.toString());
    devtools.log("Saved Successfully");
  }

  void startTimer() {
    countdownTimer1 =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    countdownTimer1?.cancel();
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
      countdownTimer1!.cancel();
    } else {
      myDuration.value = Duration(seconds: seconds);
    }
    update();
  }

  @override
  void onClose() {
    countdownTimer1?.cancel();
    super.onClose();
  }
}
