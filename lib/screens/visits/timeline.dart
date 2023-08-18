import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/controller/timeToReachSite_controller.dart';
import 'package:easy_certs/controller/workTime_controller.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/screens/components/custom_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/auth_controller.dart';
import '../../helper/app_colors.dart';
import '../../theme/text_styles.dart';
import '../components/custom_divider.dart';
import '../components/custom_two_text.dart';

class Timeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimeToReachSiteController>(builder: (controller) {
      return GetBuilder<WorkTimeController>(
        builder: (controller) {
          String strDigits(int n) => n.toString().padLeft(2, '0');
          Duration myDuration =
              Get.find<TimeToReachSiteController>().myDuration.value;
          final days = strDigits(myDuration.inDays);
          final hours = strDigits(myDuration.inHours.remainder(24));
          final minutes = strDigits(myDuration.inMinutes.remainder(60));
          final seconds = strDigits(myDuration.inSeconds.remainder(60));

          Duration workTimeDuration =
              Get.find<WorkTimeController>().myDuration.value;
          final workTimeDays = strDigits(workTimeDuration.inDays);
          final workTimeHours =
              strDigits(workTimeDuration.inHours.remainder(24));
          final workTimeMinutes =
              strDigits(workTimeDuration.inMinutes.remainder(60));
          final workTimeSeconds =
              strDigits(workTimeDuration.inSeconds.remainder(60));
          return GetBuilder<JobController>(builder: (jobController) {
            return RefreshIndicator(
              onRefresh: () async {
                AuthController authController = Get.find();
                await jobController.getJobList(authController.token.value);
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  CustomTwoText(
                    first: AppTexts.timeToReachSite,
                    second: int.parse(hours) > 0
                        ? "$hours hrs : $minutes min : $seconds sec"
                        : "$minutes min : $seconds sec",
                    applyFlex: false,
                    applyPadding: true,
                  ),
                  CustomTwoText(
                    first: AppTexts.workTime,
                    second: int.parse(workTimeHours) > 0
                        ? "$workTimeHours hrs : $workTimeMinutes min : $workTimeSeconds sec"
                        : "$workTimeMinutes min : $workTimeSeconds sec",
                    applyFlex: false,
                    applyPadding: true,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Expanded(
                    child: (jobController.selectedJob['timelines'] != null &&
                            jobController.selectedJob['timelines'].length > 0)
                        ? ListView.builder(
                            itemCount:
                                jobController.selectedJob['timelines'].length,
                            itemBuilder: (context, i) {
                              //For Reversing List
                              int index = jobController
                                      .selectedJob['timelines'].length -
                                  1 -
                                  i;
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Text(
                                    index.toString(),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Text(
                                          DateFormat.Hm()
                                              .format(DateTime.parse(
                                                  jobController.selectedJob[
                                                                  'timelines']
                                                              [index]
                                                          ['created_at'] ??
                                                      ""))
                                              .toString(),
                                          style: kTextStyle12Normal.copyWith(
                                            color: AppColors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          jobController.selectedJob['timelines']
                                                  [index]['type']['title'] ??
                                              "",
                                          style: kTextStyle12Normal.copyWith(
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Text(
                                          jobController.selectedJob['timelines']
                                                  [index]['title'] ??
                                              "",
                                          style: kTextStyle8Normal.copyWith(
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        const CustomDivider(),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : CustomEmptyWidget(text: "No Timeline Available"),
                  ),
                ],
              ),
            );
          });
        },
      );
    });
  }
}
