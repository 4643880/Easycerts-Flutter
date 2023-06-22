import 'package:easy_certs/config/routes.dart';
import 'package:easy_certs/constants.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/screens/components/custom_app_bar.dart';
import 'package:easy_certs/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/notification_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_texts.dart';
import '../components/custom_divider.dart';
import '../components/custom_empty_widget.dart';
import 'dart:developer' as devtools show log;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    getDataReady();
    super.initState();
  }

  getDataReady() async {
    NotificationController notificationController = Get.find();
    await notificationController.get();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
        builder: (notificationController) {
      return Scaffold(
        appBar: CustomAppbar(
          title: AppTexts.notifications,
          centerTitle: false,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await notificationController.get();
          },
          child: notificationController.notificationList.isNotEmpty
              ? ListView.builder(
                  itemCount: notificationController.notificationList.length,
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () async {
                            JobController jobController = Get.find();
                            jobController.changeSelectedJob(
                                notificationController
                                        .notificationList[index].jobvisit
                                        ?.toJson() ??
                                    {});
                            notificationController
                                .fromNotificationScreen.value = true;
                            Get.toNamed(routeVisitDetail);
                            // Api markMessageAsRead
                            await Get.find<NotificationController>()
                                .notificationReadMark(notificationController
                                    .notificationList[index].id
                                    .toString());
                            await notificationController.get();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 16.w,
                              right: 16.w,
                              bottom: 12.h,
                              top: 12.h,
                            ),
                            child: Obx(
                              () => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  notificationController
                                              .notificationList[index].status ==
                                          "read"
                                      ? Container()
                                      : Container(
                                          width: 6.w,
                                          height: 6.w,
                                          alignment: Alignment.topRight,
                                          margin: const EdgeInsets.only(
                                                  right: 5, top: 6)
                                              .r,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notificationController
                                                      .notificationList[index]
                                                      .title ??
                                                  "",
                                              style: kTextStyle14Normal,
                                            ),
                                            SizedBox(
                                              width: 260.w,
                                              child: Text(
                                                notificationController
                                                        .notificationList[index]
                                                        .description ??
                                                    "",
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: kFontSize12,
                                                  fontWeight: FontWeight.normal,
                                                  letterSpacing: 0.5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              notificationController
                                                      .notificationList[index]
                                                      .jobvisit
                                                      ?.refNumber ??
                                                  "",
                                              style: kTextStyle8Normal,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              notificationController
                                                          .notificationList[
                                                              index]
                                                          .createdAt !=
                                                      null
                                                  ? DateFormat.yMMMd()
                                                      .add_jm()
                                                      .format(
                                                        DateTime.parse(
                                                            notificationController
                                                                .notificationList[
                                                                    index]
                                                                .createdAt!),
                                                      )
                                                      .toString()
                                                  : "",
                                              style: kTextStyle8Normal,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      JobController jobController = Get.find();
                                      jobController.changeSelectedJob(
                                          notificationController
                                                  .notificationList[index]
                                                  .jobvisit
                                                  ?.toJson() ??
                                              {});
                                      notificationController
                                          .fromNotificationScreen.value = true;
                                      Get.toNamed(routeVisitDetail);
                                      // Api markMessageAsRead
                                      await Get.find<NotificationController>()
                                          .notificationReadMark(
                                              notificationController
                                                  .notificationList[index].id
                                                  .toString());
                                      await notificationController.get();
                                    },
                                    splashRadius: kBorderRadius20,
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 20.sp,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const CustomDivider(),
                      ],
                    );
                  })
              : CustomEmptyWidget(
                  text: "No Notification Available",
                ),
        ),
      );
    });
  }
}
