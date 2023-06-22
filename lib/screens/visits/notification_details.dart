import 'dart:async';
import 'dart:developer';
import 'package:easy_certs/constants.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/controller/notification_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as devtools show log;
import '../../helper/app_colors.dart';
import '../../helper/job_status.dart';
import '../../theme/text_styles.dart';
import '../../utils/extra_function.dart';
import '../components/Custom_Icon_and_text.dart';
import '../components/custom_divider.dart';

class NotificationDetail extends StatefulWidget {
  NotificationDetail({Key? key}) : super(key: key);

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition kGooglePlex;
  late CameraPosition lake;
  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latLang = <LatLng>[];

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(lake));
  }

  @override
  void initState() {
    setState(() {
      // Get.find<NotificationController>().fromNotificationScreen.value = false;
      JobController jobController = Get.find();
      // devtools.log(jobController.selectedJob['site']['lat']);
      // devtools.log(jobController.selectedJob['site']['long']);
      kGooglePlex = CameraPosition(
        target: LatLng(
          double.tryParse(
                  jobController.selectedJob['site']['lat'].toString()) ??
              0.0,
          double.tryParse(
                  jobController.selectedJob['site']['long'].toString()) ??
              0.0,
        ),
        zoom: 4,
        // zoom: 14.4746,
      );
      lake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(
          double.tryParse(
                  jobController.selectedJob['site']['lat'].toString()) ??
              0.0,
          double.tryParse(
                  jobController.selectedJob['site']['long'].toString()) ??
              0.0,
        ),
        tilt: 59.440717697143555,
        zoom: 4,
        // zoom: 19.151926040649414,
      );
      _latLang.add(
        LatLng(
          double.tryParse(
                  jobController.selectedJob['site']['lat'].toString()) ??
              0.0,
          double.tryParse(
                  jobController.selectedJob['site']['long'].toString()) ??
              0.0,
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('12'),
          position: LatLng(
            double.tryParse(
                    jobController.selectedJob['site']['lat'].toString()) ??
                0.0,
            double.tryParse(
                    jobController.selectedJob['site']['long'].toString()) ??
                0.0,
          ),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (jobController.selectedJob['site'] != null)
                  Expanded(
                    child: Text(
                      jobController.selectedJob['site']['name'] ?? "",
                      textAlign: TextAlign.left,
                      style: kTextStyle18Bold,
                    ),
                  ),
                if (jobController.selectedJob['job_ref_number'] != null &&
                    jobController.selectedJob['ref_number'] != null)
                  Expanded(
                    child: Text(
                      "${jobController.selectedJob['job_ref_number'] ?? " "} | ${jobController.selectedJob['ref_number'] ?? " "}",
                      textAlign: TextAlign.right,
                      style: kTextStyle12Normal.copyWith(
                          color: AppColors.secondary),
                    ),
                  ),
              ],
            ),
            if (jobController.selectedJob['job_type'] != null)
              SizedBox(
                height: 10.h,
              ),
            if (jobController.selectedJob['job_type'] != null)
              Text(
                "${jobController.selectedJob['job_type']['title'] ?? " "}",
                style: kTextStyle12Normal.copyWith(color: AppColors.secondary),
              ),
            // if (jobController.selectedJob['job_type'] != null &&
            //     jobController.selectedJob['job_category'] != null)
            //   Text(
            //     "${jobController.selectedJob['job_type']['title'] ?? " "} - ${jobController.selectedJob['job_category']['title'] ?? " "}",
            //     style: kTextStyle12Normal.copyWith(color: AppColors.secondary),
            //   ),
            SizedBox(
              height: 10.h,
            ),
            if (jobController.selectedJob['status'] != null)
              Text(
                "Status: ${JobStatus.returnJobStatus(int.parse(jobController.selectedJob['status'].toString() != "null" ? jobController.selectedJob['status'].toString() : "-1")) ?? ""}",
                style: kTextStyle12Normal.copyWith(color: AppColors.secondary),
              ),
            if (jobController.selectedJob['site'] != null)
              SizedBox(
                height: 10.h,
              ),
            if (jobController.selectedJob['site'] != null)
              CustomIconAndText(
                iconData: Icons.location_on_outlined,
                text:
                    "${jobController.selectedJob['site']['postal_code'] ?? ""}${jobController.selectedJob['site']['postal_code'] != null ? "," : ""} ${jobController.selectedJob['site']['address'] ?? ""}${jobController.selectedJob['site']['country'] != null ? "," : ""} ${jobController.selectedJob['site']['country'] ?? ""},",
              ),
            SizedBox(
              height: 10.h,
            ),
            CustomIconAndText(
              iconData: Icons.access_time,
              text: DateFormat.Hm().format(DateTime.parse(
                  jobController.selectedJob['customer']['created_at'])),
            ),
            SizedBox(
              height: 10.h,
            ),
            // ===================================================,
            Container(
              height: 160.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorderRadius8),
                color: AppColors.primary,
              ),
              alignment: Alignment.center,
              child: GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                mapType: MapType.normal,
                markers: Set<Marker>.of(_markers),
                initialCameraPosition: kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            const CustomDivider(),
            SizedBox(
              height: 16.h,
            ),
            Text(
              "Primary Person",
              style: kTextStyle14Bold,
            ),
            Row(
              children: [
                if (jobController.selectedJob['site'] != null)
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jobController.selectedJob['customer']['name'] ?? "",
                          style: kTextStyle12Normal.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          jobController.selectedJob['customer']
                                  ['phone_number'] ??
                              "",
                          style: kTextStyle11Normal.copyWith(
                              color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  onPressed: () {
                    if (jobController.selectedJob['customer'] != null) {
                      List<String> recepientsList = [
                        jobController.selectedJob['customer']['phone_number']
                            .toString(),
                      ];
                      launchSendSMS("Hello,", recepientsList);
                    }
                  },
                  splashRadius: 20.h,
                  icon: Icon(
                    Icons.message_outlined,
                    color: AppColors.secondary,
                    size: 22.h,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (jobController.selectedJob['customer'] != null) {
                      // devtools.log(jobController.selectedJob['customer']
                      //     ['phone_number']);
                      launchCaller(jobController.selectedJob['customer']
                              ['phone_number'] ??
                          "");
                    }
                  },
                  splashRadius: 20.h,
                  icon: Icon(
                    Icons.phone_in_talk,
                    color: AppColors.secondary,
                    size: 22.h,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            const CustomDivider(),
          ],
        ),
      );
    });
  }
}
