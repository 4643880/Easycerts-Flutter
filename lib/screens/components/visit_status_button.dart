import 'package:easy_certs/config/routes.dart';
import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/app_colors.dart';
import '../../utils/extra_function.dart';
import '../../utils/util.dart';
import 'bottom_sheet_button.dart';
import 'bottom_sheet_two_button.dart';

class VisitDetailBottomButton extends StatelessWidget {
  VisitDetailBottomButton({
    Key? key,
    required this.status,
  }) : super(key: key);
  int status;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
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
        case 12:
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
}
