import 'package:easy_certs/config/routes.dart';
import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/controller/timeToReachSite_controller.dart';
import 'package:easy_certs/controller/workTime_controller.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/helper/hive_boxes.dart';
import 'package:easy_certs/model/timer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../helper/app_colors.dart';
import '../../utils/extra_function.dart';
import '../../utils/util.dart';
import 'bottom_sheet_button.dart';
import 'bottom_sheet_two_button.dart';
import 'dart:developer' as devtools show log;

class VisitDetailBottomButton extends StatelessWidget {
  RxString getDate = "".obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  VisitDetailBottomButton({
    Key? key,
    required this.status,
    required this.selectedJob,
  }) : super(key: key);
  int status;
  dynamic selectedJob;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
      // Boxes.getWorkTimeModelBox().delete(AppTexts.hiveWorkTime);
      // Get.find<WorkTimeController>().myDuration.value =
      //     const Duration(seconds: 0);
      // Get.find<TimeToReachSiteController>().update();

      List<TimerModel>? listOfData = Boxes.getTimerModelBox().values.toList();
      List<TimerModel>? listOfData1 =
          Boxes.getWorkTimeModelBox().values.toList();
      // Boxes.getTimerModelBox().clear();
      // Boxes.getWorkTimeModelBox().clear();

      // Get.find<TimeToReachSiteController>().myDuration.value =
      //     const Duration(seconds: 0);
      // Get.find<TimeToReachSiteController>().update();
      // devtools.log("Deleted Successfully");

      // final box = Boxes.getTimerModelBox().get(AppTexts.hiveTimer);
      // devtools.log(box.toString());

      // devtools.log("Job Status is =>>> ${status.toString()}");
      // devtools.log("List of Time to Site DB =>>> ${listOfData.toString()}");
      // devtools.log("List of Work Time DB =>>> ${listOfData1.toString()}");
      // devtools.log("Selected Job =>>> ${selectedJob.toString()}");

      switch (status) {
        case 0:
          {
            return const SizedBox();
          }
        case 1:
          {
            return const SizedBox();
          }
        case 2:
          {
            return BottomSheetButton(
              buttonTitle: AppTexts.startTravelling,
              borderColor: AppColors.primary,
              bgColor: AppColors.primary,
              textColor: AppColors.white,
              onPressed: () async {
                bool temp = await checkVisitScheduledDate(jobController);
                if (temp) {
                  customDialogForVisitStartConfirmation(
                    context: context,
                    buttonConfirmOnTap: () async {
                      Get.back(closeOverlays: true);
                      Util.showLoading("Updating Status");
                      AuthController authController = Get.find();
                      bool temp = await jobController.updateSelectedJobStatus(
                        jobController.selectedJob['id'].toString(),
                        "4",
                        status.toString(),
                        null,
                        null,
                        authController.token.value,
                      );
                      if (temp) {
                        jobController.selectedJob['status'] = 4;
                        await Get.find<TimeToReachSiteController>()
                            .saveStartTravelTime();
                        Get.find<TimeToReachSiteController>().startTimer();
                        loadData();
                        jobController.update();
                        Util.dismiss();
                      } else {
                        Util.dismiss();
                      }
                    },
                    buttonConfirmAndOpenMapOnTap: () async {
                      Get.back(closeOverlays: true);
                      Util.showLoading("Updating Status");
                      AuthController authController = Get.find();
                      bool temp = await jobController.updateSelectedJobStatus(
                        jobController.selectedJob['id'].toString(),
                        "4",
                        status.toString(),
                        null,
                        null,
                        authController.token.value,
                      );
                      if (temp) {
                        jobController.selectedJob['status'] = 4;
                        await Get.find<TimeToReachSiteController>()
                            .saveStartTravelTime();
                        Get.find<TimeToReachSiteController>().startTimer();
                        loadData();
                        jobController.update();
                        Util.dismiss();
                      } else {
                        Util.dismiss();
                      }
                    },
                    buttonCancelOnTap: () {
                      Get.back(closeOverlays: true);
                    },
                  );
                } else {
                  showVisitCannotStartDueToDate(context);
                }
              },
            );
          }
        case 3:
          {
            return const SizedBox();
          }
        case 4:
          {
            return BottomSheetButton(
              bgColor: AppColors.success,
              textColor: AppColors.white,
              borderColor: AppColors.success,
              buttonTitle: AppTexts.arriveAtSite,
              onPressed: () {
                customDialog(
                  context: context,
                  barrierDismissible: false,
                  titleText: AppTexts.siteLocation,
                  middleText: AppTexts.visitReachedLocation,
                  afterTextWidget: null,
                  buttonLeftText: AppTexts.no,
                  buttonLeftTextOnTap: () {
                    Get.back(closeOverlays: true);
                  },
                  buttonRightText: AppTexts.yes,
                  buttonRightTextOnTap: () async {
                    Get.back(closeOverlays: true);
                    Util.showLoading("Updating Status");
                    AuthController authController = Get.find();
                    bool temp = await jobController.updateSelectedJobStatus(
                      jobController.selectedJob['id'].toString(),
                      "5",
                      status.toString(),
                      null,
                      null,
                      authController.token.value,
                    );
                    if (temp) {
                      jobController.selectedJob["status"] = 5;
                      jobController.update();
                      loadData();
                      await Get.find<TimeToReachSiteController>()
                          .saveArriveAtSiteTime();
                      Get.find<TimeToReachSiteController>().stopTimer();
                      Util.dismiss();
                    } else {
                      Util.dismiss();
                    }
                  },
                );
              },
            );
          }
        case 5:
          {
            return BottomSheetTwoButton(
              bgColor: AppColors.white,
              bgColor2: AppColors.success,
              textColor: AppColors.red,
              textColor2: AppColors.white,
              borderColor: AppColors.red,
              borderColor2: AppColors.success,
              buttonTitle: AppTexts.noAccess,
              buttonTitle2: AppTexts.startVisit,
              onPressed: () {
                Get.toNamed(routeNoAccess);
              },
              onPressed2: () {
                customDialog(
                  context: context,
                  barrierDismissible: false,
                  titleText: AppTexts.startVisit,
                  middleText: AppTexts.startVisitConformation,
                  afterTextWidget: null,
                  buttonLeftText: AppTexts.no,
                  buttonLeftTextOnTap: () {
                    Get.back(closeOverlays: true);
                  },
                  buttonRightText: AppTexts.yes,
                  buttonRightTextOnTap: () async {
                    Get.back(closeOverlays: true);
                    Util.showLoading("Updating Status");
                    AuthController authController = Get.find();
                    bool temp = await jobController.updateSelectedJobStatus(
                      jobController.selectedJob['id'].toString(),
                      "7",
                      status.toString(),
                      null,
                      null,
                      authController.token.value,
                    );
                    if (temp) {
                      jobController.selectedJob["status"] = 7;
                      jobController.update();
                      loadData();
                      await Get.find<WorkTimeController>().saveStartJobVisit();
                      Get.find<WorkTimeController>().startTimer();
                      Util.dismiss();
                    } else {
                      Util.dismiss();
                    }
                  },
                );
              },
            );
          }
        case 6:
          {
            return BottomSheetTwoButton(
              bgColor: AppColors.success,
              bgColor2: AppColors.primary,
              textColor: AppColors.white,
              textColor2: AppColors.white,
              borderColor: AppColors.success,
              borderColor2: AppColors.primary,
              buttonTitle: AppTexts.resumeVisit,
              buttonTitle2: AppTexts.startTravelling,
              onPressed: () async {
                bool temp = await checkVisitScheduledDate(jobController);
                if (temp) {
                  customDialog(
                    context: context,
                    barrierDismissible: false,
                    titleText: AppTexts.resumeVisit,
                    middleText: AppTexts.resumeVisitConformation,
                    afterTextWidget: null,
                    buttonLeftText: AppTexts.cancel,
                    buttonLeftTextOnTap: () {
                      Get.back(closeOverlays: true);
                    },
                    buttonRightText: AppTexts.yes,
                    buttonRightTextOnTap: () async {
                      Get.back(closeOverlays: true);
                      Util.showLoading("Updating Status");
                      AuthController authController = Get.find();
                      bool temp = await jobController.updateSelectedJobStatus(
                        jobController.selectedJob['id'].toString(),
                        "11",
                        status.toString(),
                        null,
                        null,
                        authController.token.value,
                      );
                      if (temp) {
                        Util.dismiss();
                      } else {
                        Util.dismiss();
                      }
                    },
                  );
                } else {
                  showVisitCannotStartDueToDate(context);
                }
              },
              onPressed2: () async {
                bool temp = await checkVisitScheduledDate(jobController);
                if (temp) {
                  customDialogForVisitStartConfirmation(
                    context: context,
                    buttonConfirmOnTap: () async {
                      Get.back(closeOverlays: true);
                      Util.showLoading("Updating Status");
                      AuthController authController = Get.find();
                      bool temp1 = await jobController.updateSelectedJobStatus(
                        jobController.selectedJob['id'].toString(),
                        "4",
                        status.toString(),
                        null,
                        null,
                        authController.token.value,
                      );
                      if (temp1) {
                        Util.dismiss();
                      } else {
                        Util.dismiss();
                      }
                    },
                    buttonConfirmAndOpenMapOnTap: () {},
                    buttonCancelOnTap: () {
                      Get.back(closeOverlays: true);
                    },
                  );
                } else {
                  showVisitCannotStartDueToDate(context);
                }
              },
            );
          }
        case 7:
          {
            return BottomSheetTwoButton(
              bgColor: AppColors.primary,
              bgColor2: AppColors.success,
              textColor: AppColors.white,
              textColor2: AppColors.white,
              borderColor: AppColors.primary,
              borderColor2: AppColors.success,
              buttonTitle: AppTexts.pauseVisit,
              buttonTitle2: AppTexts.markVisitAsComplete,
              onPressed: () {
                customDialog(
                  context: context,
                  barrierDismissible: false,
                  titleText: AppTexts.pauseVisit,
                  middleText: AppTexts.pauseVisitConformation,
                  afterTextWidget: null,
                  buttonLeftText: AppTexts.no,
                  buttonLeftTextOnTap: () {
                    Get.back(closeOverlays: true);
                  },
                  buttonRightText: AppTexts.yes,
                  buttonRightTextOnTap: () async {
                    Get.back(closeOverlays: true);
                    Util.showLoading("Updating Status");
                    AuthController authController = Get.find();
                    bool temp = await jobController.updateSelectedJobStatus(
                      jobController.selectedJob['id'].toString(),
                      "16",
                      status.toString(),
                      null,
                      null,
                      authController.token.value,
                    );
                    if (temp) {
                      jobController.selectedJob["status"] = 16;
                      loadData();
                      jobController.update();
                      await Get.find<WorkTimeController>().savePauseJobVisit();
                      Get.find<WorkTimeController>().stopTimer();
                      Util.dismiss();
                    } else {
                      Util.dismiss();
                    }
                  },
                );
              },
              onPressed2: () {
                customDialog(
                  context: context,
                  barrierDismissible: false,
                  titleText: AppTexts.completeVisit,
                  middleText: AppTexts.completeVisitConformation,
                  afterTextWidget: null,
                  buttonLeftText: AppTexts.no,
                  buttonLeftTextOnTap: () {
                    Get.back(closeOverlays: true);
                  },
                  buttonRightText: AppTexts.yes,
                  buttonRightTextOnTap: () async {
                    Get.back(closeOverlays: true);
                    Get.toNamed(routeBothSignature);
                  },
                );
              },
            );
          }
        case 8:
          {
            return const SizedBox();
          }
        case 9:
          {
            return const SizedBox();
          }
        case 10:
          {
            return const SizedBox();
          }
        case 11:
          {
            return BottomSheetTwoButton(
              bgColor: AppColors.primary,
              bgColor2: AppColors.success,
              textColor: AppColors.white,
              textColor2: AppColors.white,
              borderColor: AppColors.primary,
              borderColor2: AppColors.success,
              buttonTitle: AppTexts.pauseVisit,
              buttonTitle2: AppTexts.markVisitAsComplete,
              onPressed: () {
                customDialog(
                  context: context,
                  barrierDismissible: false,
                  titleText: AppTexts.pauseVisit,
                  middleText: AppTexts.pauseVisitConformation,
                  afterTextWidget: null,
                  buttonLeftText: AppTexts.no,
                  buttonLeftTextOnTap: () {
                    Get.back(closeOverlays: true);
                  },
                  buttonRightText: AppTexts.yes,
                  buttonRightTextOnTap: () async {
                    Get.back(closeOverlays: true);
                    Util.showLoading("Updating Status");
                    AuthController authController = Get.find();
                    bool temp = await jobController.updateSelectedJobStatus(
                      jobController.selectedJob['id'].toString(),
                      "16",
                      status.toString(),
                      null,
                      null,
                      authController.token.value,
                    );
                    if (temp) {
                      // ==================================================== Pause Job Visit =============
                      jobController.selectedJob["status"] = 16;
                      await Get.find<WorkTimeController>().savePauseJobVisit();
                      Get.find<WorkTimeController>().stopTimer();
                      loadData();
                      jobController.update();
                      Util.dismiss();
                    } else {
                      Util.dismiss();
                    }
                  },
                );
              },
              onPressed2: () {
                customDialog(
                  context: context,
                  barrierDismissible: false,
                  titleText: AppTexts.completeVisit,
                  middleText: AppTexts.completeVisitConformation,
                  afterTextWidget: null,
                  buttonLeftText: AppTexts.no,
                  buttonLeftTextOnTap: () {
                    Get.back(closeOverlays: true);
                  },
                  buttonRightText: AppTexts.yes,
                  buttonRightTextOnTap: () async {
                    Get.back(closeOverlays: true);
                    Get.toNamed(routeBothSignature);
                  },
                );
              },
            );
          }
        case 12: // ======================================= Accept and Reject =============================
          {
            return BottomSheetTwoButton(
              bgColor: AppColors.white,
              bgColor2: AppColors.success,
              textColor: AppColors.red,
              textColor2: AppColors.white,
              borderColor: AppColors.red,
              borderColor2: AppColors.success,
              buttonTitle: AppTexts.reject,
              buttonTitle2: AppTexts.accept,
              onPressed: () {
                Get.toNamed(routeRejectJob);
              },
              onPressed2: () {
                customDialog(
                  context: context,
                  barrierDismissible: false,
                  titleText: AppTexts.acceptVisit,
                  middleText: AppTexts.acceptVisitConformation,
                  afterTextWidget: null,
                  buttonLeftText: AppTexts.cancel,
                  buttonLeftTextOnTap: () {
                    Get.back(closeOverlays: true);
                  },
                  buttonRightText: AppTexts.yes,
                  buttonRightTextOnTap: () async {
                    Get.back(closeOverlays: true);
                    Util.showLoading("Updating Status");
                    AuthController authController = Get.find();
                    bool temp = await jobController.updateSelectedJobStatus(
                      jobController.selectedJob['id'].toString(),
                      "2",
                      status.toString(),
                      null,
                      null,
                      authController.token.value,
                    );
                    if (temp) {
                      jobController.selectedJob['status'] = 2;
                      jobController.pendingJobsList
                          .removeWhere((element) => element['status'] == 12);
                      loadData();
                      jobController.update();
                      devtools.log("Status Updated Successfully...");
                      Util.dismiss();
                    } else {
                      Util.dismiss();
                    }
                  },
                );
              },
            );
          }
        case 14:
          {
            return const SizedBox();
          }
        case 15:
          {
            return const SizedBox();
          }
        case 16:
          {
            return BottomSheetButton(
              bgColor: AppColors.success,
              textColor: AppColors.white,
              borderColor: AppColors.success,
              buttonTitle: AppTexts.resumeVisit,
              onPressed: () {
                customDialog(
                  context: context,
                  barrierDismissible: false,
                  titleText: AppTexts.resumeVisit,
                  middleText: AppTexts.resumeVisitConformation,
                  afterTextWidget: null,
                  buttonLeftText: AppTexts.no,
                  buttonLeftTextOnTap: () {
                    Get.back(closeOverlays: true);
                  },
                  buttonRightText: AppTexts.yes,
                  buttonRightTextOnTap: () async {
                    Get.back(closeOverlays: true);
                    Util.showLoading("Updating Status");
                    AuthController authController = Get.find();
                    bool temp = await jobController.updateSelectedJobStatus(
                      jobController.selectedJob['id'].toString(),
                      "11",
                      status.toString(),
                      null,
                      null,
                      authController.token.value,
                    );
                    if (temp) {
                      jobController.selectedJob["status"] = 11;
                      jobController.update();
                      loadData();
                      final id = Get.find<JobController>()
                          .selectedJob["id"]
                          .toString();
                      List<TimerModel>? workTimedataList =
                          Boxes.getWorkTimeModelBox().values.toList();
                      TimerModel? workTimedata;
                      workTimedataList.forEach((element) {
                        if (element.id == id) {
                          workTimedata = element;
                          Get.find<WorkTimeController>().update();
                        }
                      });

                      if (workTimedata?.pauseTime != null) {
                        Duration difference = workTimedata!.pauseTime!
                            .difference(workTimedata!.startTime!);
                        Get.find<WorkTimeController>().myDuration.value =
                            difference;
                        Get.find<WorkTimeController>().update();
                        Get.find<WorkTimeController>().startTimer();

                        // Will Start later because old value of pause an start will be remove and will assign new start value
                        await Get.find<WorkTimeController>()
                            .saveStartJobVisit(duration: difference);
                      }
                      Util.dismiss();
                    } else {
                      Util.dismiss();
                    }
                  },
                );
              },
            );
          }
        case 17:
          {
            return const SizedBox();
          }
        default:
          {
            return const SizedBox();
          }
      }
    });
  }

  Future loadData() async {
    AuthController authController = Get.find();
    // Code For Shedule Apis
    Util.showLoading("Fetching Data");

    // devtools.log(selectedDate.value.toString());
    var dateForApi = DateFormat('MM-dd-yyyy')
        .format(selectedDate.value)
        .toString()
        .replaceAll('-', "/");
    getDate.value = dateForApi;

    // devtools.log(selectedDate.value.toString());
    // Calling Three Apis
    // AuthController authController = Get.find();
    await Future.wait([
      Get.find<JobController>().getPendingJobList(
        "12",
        getDate.value,
        authController.token.value,
      ),
      Get.find<JobController>().getOngoingJobList(
        getDate.value,
        authController.token.value,
      ),
      Get.find<JobController>().getCompletedJobList(
        "1",
        getDate.value,
        authController.token.value,
      ),
    ]);
    Util.dismiss();
  }
}
