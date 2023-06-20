import 'package:easy_certs/helper/app_assets.dart';
import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/screens/dashboard/notifications_screen.dart';
import 'package:easy_certs/screens/dashboard/profile_screen.dart';
import 'package:easy_certs/screens/dashboard/schedule_screen.dart';
import 'package:easy_certs/screens/dashboard/visits_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/auth_controller.dart';
import '../../controller/dashboard_controller.dart';
import '../../controller/job_controller.dart';
import '../../utils/util.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DashboardController dashboardController = Get.find();
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxString getDate = "".obs;

  @override
  void initState() {
    getJobs();
    //   checkNotification();
    super.initState();
  }

  getJobs() async {
    Util.showLoading("Fetching Data");
    JobController jobController = Get.find();
    jobController.changeIsLoading(true);
    AuthController authController = Get.find();
    bool temp1 = await jobController.getJobList(authController.token.value);
    bool temp2 =
        await jobController.getAssignedJobList(authController.token.value);
    bool temp3 = await jobController.getTemplates(authController.token.value);
    if (temp1 && temp2 && temp3) {
      jobController.changeIsLoading(false);
      Util.dismiss();
    } else {
      jobController.changeIsLoading(false);
      Util.dismiss();
    }
  }

  // checkNotification() async {
  //   if (dashboardController.foregroundNotificationListenerCalled.isFalse) {
  //     onFgNotification(context);
  //     dashboardController.updateForegroundNotificationListenerCalled(true);
  //     await handleInitialFcmMessage(context);
  //   }
  // }

  final List<Widget> _getTabWidget = [
    VisitsScreen(),
    ScheduleScreen(),
    const NotificationScreen(),
    const ProfileScreen()
  ];

  List<BottomNavigationBarItem> _getTabItems() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: SvgPicture.asset(
            AppAssets.briefcaseSvg,
            color: dashboardController.currentIndex.value == 0
                ? AppColors.primary
                : AppColors.secondary,
            height: 24.h,
            width: 24.w,
          ),
        ),
        label: "Visits",
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: SvgPicture.asset(
            AppAssets.calendarSvg,
            color: dashboardController.currentIndex.value == 1
                ? AppColors.primary
                : AppColors.secondary,
            height: 24.h,
            width: 24.w,
          ),
        ),
        label: "Schedule",
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: SvgPicture.asset(
            AppAssets.bellSvg,
            color: dashboardController.currentIndex.value == 2
                ? AppColors.primary
                : AppColors.secondary,
            height: 24.h,
            width: 24.w,
          ),
        ),
        label: "Notifications",
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: SvgPicture.asset(
            AppAssets.userSvg,
            color: dashboardController.currentIndex.value == 3
                ? AppColors.primary
                : AppColors.secondary,
            height: 24.h,
            width: 24.w,
          ),
        ),
        label: "Profile",
      ),
    ];
  }

  Future<bool> _onWillPop() async {
    if (dashboardController.currentIndex.value == 0) {
      return true;
    }
    dashboardController.updateCurrentIndex(0);
    return false;
  }

  TextStyle labelStyle =
      TextStyle(fontSize: 10.sp, color: AppColors.transparent);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return GetBuilder<DashboardController>(builder: (dashboardController) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: IndexedStack(
              index: dashboardController.currentIndex.value,
              children: _getTabWidget,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: AppColors.white,
              elevation: 10,
              type: BottomNavigationBarType.fixed,
              items: _getTabItems(),
              currentIndex: dashboardController.currentIndex.value,
              onTap: (value) {
                dashboardController.updateCurrentIndex(value);
              },
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.secondary,
              showUnselectedLabels: true,
              selectedLabelStyle: labelStyle,
              unselectedLabelStyle: labelStyle,
            ),
          ),
        );
      });
    });
  }
}
