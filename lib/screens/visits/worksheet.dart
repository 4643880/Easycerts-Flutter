import 'dart:convert';
import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/hive_boxes.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:developer' as devtools show log;
import '../../config/routes.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_texts.dart';
import '../../theme/text_styles.dart';

class Worksheets extends StatefulWidget {
  Worksheets({Key? key}) : super(key: key);

  @override
  State<Worksheets> createState() => _WorksheetsState();
}

class _WorksheetsState extends State<Worksheets> {
  Function()? onTap(JobController jobController, dynamic newWorksheet) {
    jobController.updateSelectedWorksheet(
      newWorksheet,
    );
    Get.toNamed(routeWorksheetsDetail);
    return null;
  }

  dynamic myData;

  List<Tab> tabList = [
    Tab(
      child: Text(
        AppTexts.worksheets.toUpperCase(),
        textAlign: TextAlign.center,
        style: kTextStyle10Normal,
      ),
    ),
    Tab(
      child: Text(
        AppTexts.savedWorksheets.toUpperCase(),
        textAlign: TextAlign.center,
        style: kTextStyle10Normal,
      ),
    ),
    Tab(
      child: Text(
        AppTexts.submittedWorksheets.toUpperCase(),
        textAlign: TextAlign.center,
        style: kTextStyle10Normal,
      ),
    ),
  ];

  List<dynamic> temporaryList = [];
  getDataFromLocalStorage() async {
    Util.showLoading("Loading Data...");
    temporaryList.clear();
    await funcToFechData();
    await Future.delayed(const Duration(seconds: 1));
    // devtools.log("2: " + DateTime.now().toString());
    setState(() {
      myData = temporaryList;
    });
    Util.dismiss();
  }

  Future funcToFechData() async {
    List? listOfKeys = await Boxes.getKeysOfWorkSpaceData().get('keysOfList');
    // devtools.log(Boxes.getSavedWorkSpaceData().get(listOfKeys![0]).toString());
    listOfKeys?.forEach((element) async {
      final eachElement = await Boxes.getSavedWorkSpaceData().get(element);
      // devtools.log(eachElement.toString());
      if (eachElement["selectedJobId"] ==
          Get.find<JobController>().selectedJob["id"]) {
        temporaryList.add(eachElement);
      }
      // devtools.log("1: " + DateTime.now().toString());
    });
  }

  dynamic mySubmittedData;
  List<dynamic> temporaryList1 = [];
  getSubmittedDataFromLocalStorage() async {
    Util.showLoading("Loading Data...");
    temporaryList1.clear();
    await funcToFechSubmittedData();
    await Future.delayed(const Duration(seconds: 1));
    // devtools.log("2: " + DateTime.now().toString());
    setState(() {
      mySubmittedData = temporaryList1;
    });
    Util.dismiss();
  }

  Future funcToFechSubmittedData() async {
    List? listOfKeys =
        await Boxes.getKeysOfSubmittedWorkSpaceData().get('keysOfList');
    // devtools.log(Boxes.getSavedWorkSpaceData().get(listOfKeys![0]).toString());
    listOfKeys?.forEach((element) async {
      final eachElement = await Boxes.getSubmittedWorkSpaceData().get(element);
      // devtools.log(eachElement.toString());
      if (eachElement["selectedJobId"] ==
          Get.find<JobController>().selectedJob["id"]) {
        temporaryList1.add(eachElement);
      }
      // devtools.log("each Element: " + eachElement.toString());
    });
  }

  @override
  void initState() {
    setState(() {
      getDataFromLocalStorage();
      getSubmittedDataFromLocalStorage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
      // final li = jobController.selectedJob['worksheets'] as List;
      // final submittedList = li
      //     .where(
      //       (element) => element["is_submitted"] == true,
      //     )
      //     .toList();
      // devtools.log(submittedList.toString());
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: AppColors.white,
            elevation: 0,
            bottom: TabBar(
              tabs: tabList,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.secondary,
              indicatorColor: AppColors.primary,
              labelStyle: kTextStyle12Normal.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  AuthController authController = Get.find();
                  await jobController.getJobList(authController.token.value);
                },
                child: ListView(
                  children: [
                    (jobController.selectedJob['worksheets'] != null &&
                            jobController.selectedJob['worksheets'].isNotEmpty)
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                jobController.selectedJob['worksheets'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    Util.showLoading("Please wait...");
                                    await Future.delayed(
                                        const Duration(milliseconds: 100));
                                    onTap(
                                      jobController,
                                      jobController.selectedJob['worksheets']
                                          [index],
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              jobController
                                                      .selectedJob['worksheets']
                                                  [index]['name'],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              onTap(
                                                jobController,
                                                jobController.selectedJob[
                                                    'worksheets'][index],
                                              );
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16.sp,
                                            ),
                                            splashRadius: 25.r,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      const Divider(
                                        height: 2,
                                        color: AppColors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: 320.h),
                            child: const Center(
                              child: Text("No Worksheets Available"),
                            ),
                          ),
                  ],
                ),
              ),
              //saved================================
              RefreshIndicator(
                onRefresh: () async {
                  // =========================================================================================
                  // AuthController authController = Get.find();
                  // await jobController.getJobList(authController.token.value);
                  await getDataFromLocalStorage();
                },
                child: ListView(
                  children: [
                    myData != null && myData.length > 0
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: myData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    // ============================================================================
                                    await getDataFromLocalStorage();
                                    onTap(
                                      jobController,
                                      myData[index]["worksheetData"],
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              myData[index]["worksheetData"]
                                                  ['name'],
                                              // jobController
                                              //         .selectedJob['worksheets']
                                              //     [index]['name'],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await getDataFromLocalStorage();
                                              onTap(
                                                jobController,
                                                myData[index]["worksheetData"],
                                              );
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16.sp,
                                            ),
                                            splashRadius: 25.r,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      const Divider(
                                        height: 2,
                                        color: AppColors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: 320.h),
                            child: const Center(
                              child: Text(
                                "No Worksheets Available",
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              // Submitted
              RefreshIndicator(
                onRefresh: () async {
                  // AuthController authController = Get.find();
                  // await jobController.getJobList(authController.token.value);
                  await getSubmittedDataFromLocalStorage();
                },
                child: ListView(
                  children: [
                    (mySubmittedData != null && mySubmittedData.length > 0)
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: mySubmittedData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    onTap(
                                      jobController,
                                      mySubmittedData[index]["worksheetData"],
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              mySubmittedData[index]
                                                  ["worksheetData"]['name'],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              onTap(
                                                jobController,
                                                mySubmittedData[index]
                                                    ["worksheetData"],
                                              );
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16.sp,
                                            ),
                                            splashRadius: 25.r,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      const Divider(
                                        height: 2,
                                        color: AppColors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: 320.h),
                            child: const Center(
                              child: Text("No Worksheets Available"),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
