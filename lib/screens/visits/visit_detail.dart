import 'dart:developer';

import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/controller/notification_controller.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/screens/components/custom_app_bar.dart';
import 'package:easy_certs/screens/visits/notes.dart';
import 'package:easy_certs/screens/visits/notification_details.dart';
import 'package:easy_certs/screens/visits/purchase_orders.dart';
import 'package:easy_certs/screens/visits/quotes.dart';
import 'package:easy_certs/screens/visits/timeline.dart';
import 'package:easy_certs/screens/visits/worksheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/app_colors.dart';
import '../../theme/text_styles.dart';
import '../components/visit_status_button.dart';
import 'detail.dart';

class VisitDetail extends StatelessWidget {
  VisitDetail({Key? key}) : super(key: key);
  RxBool showBottomButton = true.obs;

  List<Tab> tabList = [
    Tab(
      text: AppTexts.details.toUpperCase(),
    ),
    Tab(
      text: AppTexts.worksheets.toUpperCase(),
    ),
    Tab(
      text: AppTexts.timeline.toUpperCase(),
    ),
    Tab(
      text: AppTexts.notes.toUpperCase(),
    ),
    // Tab(
    //   text: AppTexts.quotes.toUpperCase(),
    // ),
    // Tab(
    //   text: AppTexts.purchaseOrders.toUpperCase(),
    // ),
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
      return DefaultTabController(
        length: 4,
        child: Obx(
          () => Scaffold(
            appBar: CustomAppbar(
              title:
                  "${AppTexts.visitDetail} - ${jobController.selectedJob['ref_number'] ?? ""} ",
              displayLeading: true,
              centerTitle: false,
              bottom: TabBar(
                isScrollable: true,
                tabs: tabList,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.white,
                indicatorColor: AppColors.white,
                labelStyle: kTextStyle12Normal.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                onTap: (index) {
                  if (index == 0) {
                    showBottomButton.value = true;
                  } else {
                    showBottomButton.value = false;
                  }
                },
              ),
            ),
            bottomSheet: showBottomButton.isTrue
                ? VisitDetailBottomButton(
                    status: jobController.selectedJob['status'] ?? -1,
                  )
                : null,
            body: TabBarView(
              physics: const BouncingScrollPhysics(),
              dragStartBehavior: DragStartBehavior.down,
              children: [
                Get.find<NotificationController>()
                            .fromNotificationScreen
                            .value ==
                        true
                    ? NotificationDetail()
                    : Detail(),
                Worksheets(),
                const Timeline(),
                Notes(),
                // const Quotes(),
                // const PurchaseOrders(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
