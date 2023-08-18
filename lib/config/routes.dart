import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/controller/timeToReachSite_controller.dart';
import 'package:easy_certs/controller/workTime_controller.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/helper/hive_boxes.dart';
import 'package:easy_certs/model/timer_model.dart';
import 'package:easy_certs/screens/authentication/login_screen.dart';
import 'package:easy_certs/screens/dashboard/dashboard.dart';
import 'package:easy_certs/screens/image_view/image_view.dart';
import 'package:easy_certs/screens/pdf_view/pdf_view.dart';
import 'package:easy_certs/screens/reject_job/reject_job.dart';
import 'package:easy_certs/screens/splash/splash_screen.dart';
import 'package:easy_certs/screens/visits/notes_screens/display_selected_img_of_notes.dart';
import 'package:easy_certs/screens/visits/notes_screens/type_note_screen.dart';
import 'package:easy_certs/screens/visits/notes_screens/type_signature_screen.dart';
import 'package:easy_certs/screens/visits/visit_detail.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/both_signature/both_signature.dart';
import '../screens/no_access/no_access.dart';
import '../screens/visit_checkout/checkout.dart';
import '../screens/visits/worksheets_detail/worksheets_detail_screen.dart';
import '../utils/keyboard_dismiss.dart';
import 'dart:developer' as devtools show log;

const routeSplash = '/routeSplash';
const routeLogin = '/routeLogin';
const routeDashboard = '/routeDashboard';
const routeWorksheetsDetail = '/routeWorksheetsDetail';
const routeVisitDetail = '/routeVisitDetail';
const routeImageView = '/routeImageView';
const routePdfView = '/routePdfView';
const routeBothSignature = '/routeBothSignature';
const routeVisitCheckout = '/routeVisitCheckout';
const routeRejectJob = '/routeRejectJob';
const routeNoAccess = '/routeNoAccess';
const routeDisplayImageOfNote = "/routeDisplayImageOfNote";
const routeTypeNote = "/routeTypeNote";
const routeTypeSignature = "/routeTypeSignature";

class Routes {
  static final routes = [
    GetPage(name: routeSplash, page: () => const TKDismiss(SplashScreen())),
    GetPage(name: routeLogin, page: () => TKDismiss(LoginScreen())),
    GetPage(
      name: routeDashboard,
      page: () => const TKDismiss(Dashboard()),
    ),
    GetPage(
        name: routeWorksheetsDetail,
        page: () => const TKDismiss(WorksheetsDetailScreen()),
        binding: BindingsBuilder(() {
          // Util.showLoading("Please Wait From Binding...");
        })),
    GetPage(
      name: routeVisitDetail,
      transition: Transition.noTransition,
      transitionDuration: const Duration(seconds: 0),
      page: () => TKDismiss(VisitDetail()),
      binding: BindingsBuilder(() async {
        // =================== Time to Reach Site Starts Here ========================
        Get.put(
          TimeToReachSiteController(),
        );
        Get.put(
          WorkTimeController(),
        );

        List<TimerModel>? listOfData = Boxes.getTimerModelBox().values.toList();

        TimerModel? data;
        for (var element in listOfData) {
          if (element.id ==
              Get.find<JobController>().selectedJob["id"].toString()) {
            data = element;
          }
        }

        await Future.delayed(const Duration(seconds: 1));

        if (data?.id ==
            Get.find<JobController>().selectedJob["id"].toString()) {
          if (data?.endTime == null) {
            devtools.log(
                '*************************** 5555555555 ********************************');
            if (data?.startTime != null) {
              Duration difference = DateTime.now().difference(data!.startTime!);
              Get.find<TimeToReachSiteController>().myDuration.value =
                  difference;
              Get.find<TimeToReachSiteController>().startTimer();
              Get.find<TimeToReachSiteController>().update();
            }
          }
          if (data?.endTime != null) {
            devtools.log(
                '************************ 66666666 ***********************************');
            Duration difference = data!.endTime!.difference(data.startTime!);
            Get.find<TimeToReachSiteController>().myDuration.value = difference;
            Get.find<TimeToReachSiteController>().stopTimer();
            Get.find<TimeToReachSiteController>().update();
          }

          devtools.log("Start Time => ${data?.startTime.toString()}");
          devtools.log("End Time => ${data?.endTime.toString()}");
        }

        // =================== Work Time Starts Here ========================

        List<TimerModel>? listOfData2 =
            Boxes.getWorkTimeModelBox().values.toList();

        TimerModel? workTimedata;
        listOfData2.forEach((element) {
          if (element.id ==
              Get.find<JobController>().selectedJob["id"].toString()) {
            workTimedata = element;
          }
        });

        await Future.delayed(const Duration(seconds: 1));
        // final workTimedata =
        //     Boxes.getWorkTimeModelBox().get(AppTexts.hiveWorkTime);

        if (workTimedata?.id ==
            Get.find<JobController>().selectedJob["id"].toString()) {
          if (workTimedata?.endTime == null) {
            if (workTimedata?.pauseTime == null) {
              if (workTimedata?.startTime != null) {
                Duration difference =
                    DateTime.now().difference(workTimedata!.startTime!);
                Get.find<WorkTimeController>().myDuration.value = difference;
                Get.find<WorkTimeController>().startTimer();
                Get.find<WorkTimeController>().update();
              }
            }
          }
          if (workTimedata?.pauseTime != null) {
            Duration difference =
                workTimedata!.pauseTime!.difference(workTimedata!.startTime!);
            Get.find<WorkTimeController>().myDuration.value = difference;
            Get.find<WorkTimeController>().update();
          }
          if (workTimedata?.endTime != null) {
            Duration difference =
                workTimedata!.endTime!.difference(workTimedata!.startTime!);
            Get.find<WorkTimeController>().myDuration.value = difference;
            Get.find<WorkTimeController>().update();
          }
          devtools.log(
            "Work Time Start Time => ${workTimedata?.startTime.toString()}",
          );
          devtools.log(
            "Work Time Pause Time => ${workTimedata?.pauseTime.toString()}",
          );
          devtools.log(
            "Work Time End Time => ${workTimedata?.endTime.toString()}",
          );
        }
      }),
    ),
    GetPage(
        name: routeImageView,
        page: () => TKDismiss(
            ImageView(imageViewModel: Get.arguments as ImageViewModel))),
    GetPage(
        name: routePdfView,
        page: () => TKDismiss(PdfView(url: Get.arguments as String))),
    GetPage(name: routeBothSignature, page: () => TKDismiss(BothSignature())),
    GetPage(name: routeVisitCheckout, page: () => TKDismiss(VisitCheckout())),
    GetPage(name: routeRejectJob, page: () => const TKDismiss(RejectJob())),
    GetPage(name: routeNoAccess, page: () => const TKDismiss(NoAccess())),
    GetPage(
      name: routeDisplayImageOfNote,
      page: () => TKDismiss(
        DisplayNotesImageScreen(),
      ),
    ),
    GetPage(
      name: routeTypeNote,
      page: () => TKDismiss(
        TypeNoteScreen(),
      ),
    ),
    GetPage(
      name: routeTypeSignature,
      page: () => TKDismiss(
        TypeSignatureScreen(),
      ),
    ),
  ];
}

// Tap Keyboard dismiss
class TKDismiss extends StatelessWidget {
  const TKDismiss(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(child: child);
  }
}
