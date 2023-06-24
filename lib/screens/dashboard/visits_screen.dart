import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/helper/app_assets.dart';
import 'package:easy_certs/screens/components/custom_animate_switcher.dart';
import 'package:easy_certs/screens/components/custom_app_bar.dart';
import 'package:easy_certs/screens/dashboard/schedule/schedule_listing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/job_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_texts.dart';
import '../../theme/text_styles.dart';
import '../../utils/extra_function.dart';
import '../../utils/util.dart';
import 'dart:developer' as devtools show log;

class VisitsScreen extends StatefulWidget {
  VisitsScreen({Key? key}) : super(key: key);

  @override
  State<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  RxString getDate = "".obs;

  RxBool showSearchBar = false.obs;
  RxBool showSearchCalendar = false.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  List<Tab> tabList = [
    Tab(
      text: AppTexts.assignedVisits.toUpperCase(),
    ),
    Tab(
      text: AppTexts.allVisits.toUpperCase(),
    ),
  ];

  @override
  void initState() {
    loadData();
    super.initState();
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
    ]);

    Util.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
      return Obx(
        () => WillPopScope(
          onWillPop: () async {
            await Future.delayed(const Duration(milliseconds: 100), () {
              if (showSearchBar.isTrue) {
                showSearchBar.value = false;
              }
            });
            return false;
          },
          child: CustomAnimateSwitcher(
            child: showSearchBar.isFalse
                ? DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: CustomAppbar(
                        title: AppTexts.visits,
                        centerTitle: false,
                        action: [
                          IconButton(
                            onPressed: () {
                              showSearchBar.value = !showSearchBar.value;
                            },
                            icon: Icon(
                              Icons.search,
                              color: AppColors.white,
                              size: 30.h,
                            ),
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          IconButton(
                            onPressed: () async {
                              showSearchCalendar.value = true;
                              await pickDateAndAssign(context, false, false)
                                  .then((value) {
                                if (value != null) {
                                  selectedDate.value = value;
                                  //   // devtools.log("old " + temp.toString());
                                  var dateForApi = DateFormat('yyyy-MM-dd')
                                      .format(selectedDate.value)
                                      .toString();
                                  // .replaceAll('-', "/");
                                  getDate.value = dateForApi;
                                }
                              });
                              devtools.log(getDate.value.toString());

                              final listOfSearchedJobs =
                                  Get.find<JobController>()
                                      .jobsList
                                      .where(
                                        (p0) => p0["customer"]["created_at"]
                                            .toLowerCase()
                                            .contains(
                                              getDate.value.toString(),
                                            ),
                                      )
                                      .toList();

                              Get.find<JobController>()
                                  .listOfSearchedJobs
                                  .value = listOfSearchedJobs;

                              devtools.log(listOfSearchedJobs.toString());

                              // ================ old Code starts here ====================
                              // customDialog(
                              //   context: Get.context!,
                              //   barrierDismissible: false,
                              //   titleText: "Api Test",
                              //   middleText: "",
                              //   afterTextWidget: null,
                              //   buttonLeftText: "WorkTime Api",
                              //   buttonLeftTextOnTap: () async {
                              //     Get.back(closeOverlays: true);
                              //     Util.showLoading("Update Worked Time");
                              //     bool temp =
                              //         await jobController.jobUpdateWorkedTime(
                              //       jobController.selectedJob['id'].toString(),
                              //       "1000",
                              //     );
                              //     if (temp) {
                              //       Util.dismiss();
                              //     } else {
                              //       Util.dismiss();
                              //     }
                              //   },
                              //   buttonRightText: "Location Api",
                              //   buttonRightTextOnTap: () async {
                              //     Get.back(closeOverlays: true);
                              //     await checkLocationPermissionAndAskForLocation(
                              //         context);
                              //   },
                              // );

                              // DateTime? temp = await pickDateAndAssign(
                              //     context, false, false);
                              // if (temp != null) {
                              //   selectedDate.value = temp;
                              // }
                            },
                            icon: SvgPicture.asset(
                              AppAssets.calendarSvg,
                              color: AppColors.white,
                              height: 26.h,
                              width: 26.w,
                            ),
                          ),
                        ],
                        bottom: TabBar(
                          tabs: tabList,
                          labelColor: AppColors.white,
                          unselectedLabelColor: AppColors.white,
                          indicatorColor: AppColors.white,
                          labelStyle: kTextStyle12Normal.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      body: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        dragStartBehavior: DragStartBehavior.down,
                        children: [
                          ScheduleListing(
                            onRefresh: () async {
                              // Assigning Date
                              var dateForApi = DateFormat('MM-dd-yyyy')
                                  .format(selectedDate.value)
                                  .toString()
                                  .replaceAll('-', '/');
                              getDate.value = dateForApi;
                              // devtools.log("pakistan: " + getDate.value);
                              // Calling Api
                              AuthController authController = Get.find();
                              await Get.find<JobController>().getPendingJobList(
                                "12",
                                getDate.value,
                                authController.token.value,
                              );
                              await Future.delayed(
                                  const Duration(seconds: 2), () {});
                            },
                            height: 310.h,
                            isLoading: jobController.isLoading.value,
                            fromWhichVisit: FromWhichVisit.pending,
                            listLength: jobController.pendingJobsList.length,
                            list: jobController.pendingJobsList,
                          ),
                          showSearchCalendar.value == false
                              ? ScheduleListing(
                                  onRefresh: () async {
                                    AuthController authController = Get.find();
                                    await jobController
                                        .getJobList(authController.token.value);
                                  },
                                  height: 310.h,
                                  isLoading: jobController.isLoading.value,
                                  fromWhichVisit: FromWhichVisit.allVisits,
                                  listLength: jobController.jobsList.length,
                                  list: jobController.jobsList,
                                )
                              : ScheduleListing(
                                  onRefresh: () async {
                                    showSearchCalendar.value = false;
                                    // AuthController authController = Get.find();
                                    // await jobController
                                    //     .getJobList(authController.token.value);
                                  },
                                  height: 310.h,
                                  isLoading: jobController.isLoading.value,
                                  fromWhichVisit: FromWhichVisit.searchVisits,
                                  listLength:
                                      jobController.listOfSearchedJobs.length,
                                  list: jobController.listOfSearchedJobs,
                                ),
                        ],
                      ),
                    ),
                  )
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor: AppColors.white,
                      elevation: 0.5,
                      leadingWidth: 34.w,
                      leading: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: IconButton(
                          onPressed: () {
                            showSearchBar.value = false;
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 24.h,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      title: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppTexts.search,
                          hintStyle: kTextStyle12Normal,
                        ),
                        onChanged: (value) {
                          final listOfSearchedJobs = Get.find<JobController>()
                              .jobsList
                              .where((p0) => p0["customer"]["name"]
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();

                          Get.find<JobController>().listOfSearchedJobs.value =
                              listOfSearchedJobs;
                          devtools.log(listOfSearchedJobs.toString());
                        },
                      ),
                    ),
                    body: ScheduleListing(
                      onRefresh: () async {
                        AuthController authController = Get.find();
                        await jobController
                            .getJobList(authController.token.value);
                      },
                      height: 310.h,
                      isLoading: jobController.isLoading.value,
                      fromWhichVisit: FromWhichVisit.searchVisits,
                      listLength: jobController.listOfSearchedJobs.length,
                      list: jobController.listOfSearchedJobs,
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
