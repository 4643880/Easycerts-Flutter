import 'dart:async';

import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/app_assets.dart';
import 'package:easy_certs/screens/dashboard/schedule/schedule_listing.dart';
import 'package:easy_certs/theme/text_styles.dart';
import 'package:easy_certs/utils/extra_function.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as devtools show log;
import '../../helper/app_colors.dart';
import '../../helper/app_texts.dart';
import '../components/custom_animate_switcher.dart';
import '../components/custom_app_bar.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late GoogleMapController _controller;

  late CameraPosition kGooglePlex;
  late CameraPosition lake;
  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latLang = <LatLng>[];

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(lake));
  // }

  @override
  void initState() {
    setState(() {
      AuthController authController = Get.find();
      kGooglePlex = CameraPosition(
        target: LatLng(
          double.parse(authController.userModel.value.engineer?.currentLat ??
              "25.1929837"),
          double.parse(authController.userModel.value.engineer?.currentLong ??
              "66.4959581"),
        ),
        zoom: 4,
        // zoom: 14.4746,
      );
      lake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(
          double.parse(authController.userModel.value.engineer?.currentLat ??
              "25.1929837"),
          double.parse(authController.userModel.value.engineer?.currentLong ??
              "66.4959581"),
        ),
        tilt: 59.440717697143555,
        zoom: 4,
        // zoom: 19.151926040649414,
      );
      _latLang.add(const LatLng(
        31.4831037,
        74.0047239,
      ));
      _markers.add(
        Marker(
          markerId: const MarkerId('12'),
          position: LatLng(
            double.parse(authController.userModel.value.engineer?.currentLat ??
                "25.1929837"),
            double.parse(authController.userModel.value.engineer?.currentLong ??
                "66.4959581"),
          ),
        ),
      );
    });

    loadData();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  RxBool showMap = false.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  RxString getDate = "".obs;

  List<Tab> tabList = [
    Tab(
      text: AppTexts.pending.toUpperCase(),
    ),
    Tab(
      text: AppTexts.onGoing.toUpperCase(),
    ),
    Tab(
      text: AppTexts.completed.toUpperCase(),
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: AppTexts.mySchedule,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            height: 60.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            color: AppColors.primary,
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    await pickDateAndAssign(context, false, false)
                        .then((value) {
                      if (value != null) {
                        selectedDate.value = value;
                        // devtools.log("old " + temp.toString());
                        var dateForApi = DateFormat('MM-dd-yyyy')
                            .format(selectedDate.value)
                            .toString()
                            .replaceAll('-', "/");
                        getDate.value = dateForApi;
                      }
                    });

                    devtools.log(selectedDate.value.toString());
                    // Calling Three Apis
                    Util.showLoading("Fetching Data");
                    AuthController authController = Get.find();
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

                    // devtools.log("new: ${getDate.value}");
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.calendarSvg,
                        color: AppColors.white,
                        height: 30.h,
                        width: 30.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Obx(
                        () => Text(
                          DateFormat.yMMMd()
                              .format(selectedDate.value)
                              .toString(),
                          style: kTextStyle14Normal.copyWith(
                              color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    print("Left");
                    Util.showLoading("Fetching Data");
                    selectedDate.value =
                        selectedDate.value.subtract(const Duration(days: 1));

                    devtools.log(selectedDate.value.toString());
                    var dateForApi = DateFormat('MM-dd-yyyy')
                        .format(selectedDate.value)
                        .toString()
                        .replaceAll('-', "/");
                    getDate.value = dateForApi;

                    devtools.log(selectedDate.value.toString());
                    // Calling Three Apis
                    AuthController authController = Get.find();
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
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.white,
                    size: 26.h,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    print("Right");
                    Util.showLoading("Fetching Data");

                    selectedDate.value =
                        selectedDate.value.add(const Duration(days: 1));

                    devtools.log(selectedDate.value.toString());
                    var dateForApi = DateFormat('MM-dd-yyyy')
                        .format(selectedDate.value)
                        .toString()
                        .replaceAll('-', "/");
                    getDate.value = dateForApi;

                    devtools.log(selectedDate.value.toString());
                    // Calling Three Apis
                    AuthController authController = Get.find();
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
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.white,
                    size: 26.h,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                IconButton(
                  onPressed: () {
                    showMap.value = !showMap.value;
                  },
                  icon: Obx(() => CustomAnimateSwitcher(
                        child: showMap.isFalse
                            ? Icon(
                                Icons.map_outlined,
                                color: AppColors.white,
                                size: 30.h,
                              )
                            : Icon(
                                Icons.menu_rounded,
                                color: AppColors.white,
                                size: 30.h,
                              ),
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => CustomAnimateSwitcher(
                child: showMap.isFalse
                    ? DefaultTabController(
                        length: 3,
                        child: Scaffold(
                          appBar: AppBar(
                            toolbarHeight: 0,
                            bottom: TabBar(
                              tabs: tabList,
                              labelColor: AppColors.primary,
                              unselectedLabelColor: AppColors.secondary,
                              indicatorColor: AppColors.primary,
                              labelStyle: kTextStyle12Normal.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: AppColors.white,
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
                                  await Get.find<JobController>()
                                      .getPendingJobList(
                                    "12",
                                    getDate.value,
                                    authController.token.value,
                                  );
                                  await Future.delayed(
                                      const Duration(seconds: 2), () {});
                                },
                                height: 250.h,
                                isLoading: false,
                                fromWhichVisit: FromWhichVisit.pending,
                                listLength: Get.find<JobController>()
                                    .pendingJobsList
                                    .length,
                                list: Get.find<JobController>().pendingJobsList,
                              ),
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
                                  await Get.find<JobController>()
                                      .getOngoingJobList(
                                    getDate.value,
                                    authController.token.value,
                                  );
                                },
                                height: 250.h,
                                isLoading: false,
                                fromWhichVisit: FromWhichVisit.ongoing,
                                listLength: Get.find<JobController>()
                                    .onGoingJobsList
                                    .length,
                                list: Get.find<JobController>().onGoingJobsList,
                              ),
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
                                  await Get.find<JobController>()
                                      .getCompletedJobList(
                                    "1",
                                    getDate.value,
                                    authController.token.value,
                                  );
                                  // await Future.delayed(
                                  //     const Duration(seconds: 2), () {});
                                },
                                height: 250.h,
                                isLoading: false,
                                fromWhichVisit: FromWhichVisit.complete,
                                listLength: Get.find<JobController>()
                                    .completedJobsList
                                    .length,
                                list:
                                    Get.find<JobController>().completedJobsList,
                                // onRefresh: () async {
                                //   await Future.delayed(
                                //       const Duration(seconds: 2), () {});
                                // },
                                // height: 250.h,
                                // isLoading: false,
                                // fromWhichVisit: FromWhichVisit.complete,
                                // listLength: 0,
                                // list: [],
                              ),
                            ],
                          ),
                        ),
                      )
                    : GoogleMap(
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        mapType: MapType.normal,
                        markers: Set<Marker>.of(_markers),
                        initialCameraPosition: kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
