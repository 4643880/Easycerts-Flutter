import 'package:easy_certs/constants.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/helper/job_status.dart';
import 'package:easy_certs/screens/components/custom_empty_widget.dart';
import 'package:easy_certs/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/routes.dart';
import '../../components/Custom_Icon_and_text.dart';

enum FromWhichVisit { pending, ongoing, complete, assignedVisits, allVisits }

class ScheduleListing extends StatelessWidget {
  ScheduleListing({
    Key? key,
    required this.isLoading,
    required this.fromWhichVisit,
    required this.height,
    required this.listLength,
    required this.onRefresh,
    required this.list,
  }) : super(key: key);
  FromWhichVisit fromWhichVisit;
  int listLength;
  double height;
  Future<void> Function() onRefresh;
  List<dynamic> list;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: listLength != 0
          ? ListView.builder(
              itemCount: listLength,
              reverse: false,
              itemBuilder: (context, i) {
                // print(list[i]['start_time']);
                //For Reversing List
                int index = listLength - 1 - i;
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: InkWell(
                    onTap: () {
                      JobController jobController = Get.find();
                      jobController.changeSelectedJob(list[index]);
                      Get.toNamed(routeVisitDetail);
                    },
                    borderRadius: BorderRadius.circular(kBorderRadius10),
                    child: Ink(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(kBorderRadius10),
                          border: (list[index]['status'] != null &&
                                  list[index]['status'] != 2 &&
                                  list[index]['status'] != 12 &&
                                  list[index]['status'] != 5 &&
                                  list[index]['status'] != 4)
                              ? Border.all(color: AppColors.primary, width: 1)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey.withOpacity(0.4),
                              offset: const Offset(0, 2),
                              blurRadius: kBorderRadius4,
                              spreadRadius: kBorderRadius4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    list[index]['customer']['created_at'] !=
                                            null
                                        ? DateFormat.yMd()
                                            .format(DateTime.parse(list[index]
                                                ['customer']['created_at']))
                                            .toString()
                                        : "",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${list[index]['job_ref_number'] ?? " "} | ${list[index]['ref_number'] ?? " "}",
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            if (list[index]['customer'] != null)
                              Text(
                                list[index]['customer']['name'] ?? "",
                                style: kTextStyle14Bold,
                              ),
                            if (list[index]['job_type'] != null)
                              SizedBox(
                                height: 8.h,
                              ),
                            // if (list[index]['job_type'] != null ||
                            //     list[index]['job_category'] != null)
                            //   Text(
                            //     "${list[index]['job_type']['title'] ?? " "} - ${list[index]['job_category']['title'] ?? " "}",
                            //     style: kTextStyle11Normal,
                            //   ),
                            if (list[index]['job_type'] != null)
                              Text(
                                "${list[index]['job_type']['title'] ?? " "}",
                                style: kTextStyle11Normal,
                              ),
                            SizedBox(
                              height: 8.h,
                            ),
                            CustomIconAndText(
                              iconData: Icons.access_time,
                              text: list[index]['start_time'] ?? "",
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            if (list[index]['status'] != null)
                              Text(
                                "Status: ${JobStatus.returnJobStatus(int.parse(list[index]['status'].toString() != "null" ? list[index]['status'].toString() : "-1")) ?? ""}",
                                style: kTextStyle11Normal.copyWith(
                                  color: (list[index]['status'] != null &&
                                          list[index]['status'] != 2 &&
                                          list[index]['status'] != 12 &&
                                          list[index]['status'] != 5 &&
                                          list[index]['status'] != 4)
                                      ? AppColors.primary
                                      : null,
                                ),
                              ),
                            SizedBox(
                              height: 8.h,
                            ),
                            CustomIconAndText(
                              iconData: Icons.location_on_outlined,
                              text:
                                  "${list[index]['site']['postal_code'] ?? ""} ${list[index]['site']['postal_code'] != null ? "," : ""} ${list[index]['site']['address'] ?? ""}${list[index]['site']['country'] != null ? "," : ""} ${list[index]['site']['country'] ?? ""},",
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  JobController jobController = Get.find();
                                  jobController.changeSelectedJob(list[index]);
                                  Get.toNamed(routeVisitDetail);
                                },
                                child: Text(
                                  AppTexts.view.toUpperCase(),
                                  style: kTextStyle12Normal.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                );
              },
            )
          : isLoading
              ? const SizedBox()
              : CustomEmptyWidget(text: AppTexts.noVisitFound, height: height),
    );
  }
}
