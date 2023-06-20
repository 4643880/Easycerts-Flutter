import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/screens/components/large_button.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants.dart';
import '../helper/app_colors.dart';
import '../theme/text_styles.dart';

String? emailValidator(String? value, String? validationError) {
  value = value.toString().trim();

  if (value == 'null' || value.isEmpty) {
    return validationError ?? "empty_field";
  } else if (!value.contains("@") || !value.contains(".")) {
    return 'invalid_email';
  }
  return null;
}

String? passwordValidator(String? value, String? validationError) {
  value = value.toString().trim();
  if (value == 'null' || value.isEmpty) {
    return validationError ?? "empty_field";
  } else if (value.length < 8) {
    return "*Password must be at least 8 characters.";
  }
  return null;
}
//
// String? phoneValidator(String? value, String? validationError) {
//   value = value.toString().trim();
//   if (value == 'null' || value.isEmpty) {
//     return validationError ?? "empty_field";
//   } else if (value.isNumericOnly) {
//     return null;
//   } else {
//     return "*Phone no is invalid.";
//   }
// }

String? simpleValidator(String? value, String? validationMsg) {
  value = value.toString().trim();
  if (value == 'null' || value.isEmpty) {
    return validationMsg ?? "empty_field";
  }
  return null;
}

Map<String, String> setListOptions(String listOptions) {
  listOptions = listOptions.replaceAll('\\', "");
  listOptions = listOptions.replaceAll('"', '');
  listOptions = listOptions.replaceAll('{', '');
  listOptions = listOptions.replaceAll('}', '');
  Map<String, String> tempMap = {};
  for (int i = 0; i < listOptions.length; i++) {
    bool tempCheck = listOptions[i] == ",";
    if (tempCheck) {
      String value = listOptions.substring(0, i);
      listOptions = listOptions.substring(
        i + 1,
      );
      i = 0;
      int index = value.indexOf(":");
      String showValue = value.substring(0, index);
      String showKey = value.substring(
        index + 1,
      );
      tempMap.addAll({showKey: showValue});
    } else if (listOptions.isNotEmpty && !listOptions.contains(",")) {
      String value = listOptions.substring(
        0,
      );
      int index = value.indexOf(":");
      String showValue = value.substring(0, index);
      String showKey = value.substring(
        index + 1,
      );
      tempMap.addAll({showKey: showValue});
    }
  }
  return tempMap;
}

buildShowModalBottomSheet(BuildContext context, VoidCallback onCameraTap,
    VoidCallback onGalleryTap) async {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: 140.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onCameraTap,
                splashColor: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 60.h,
                      color: AppColors.purple,
                    ),
                    Text(
                      "Camera",
                      style: kTextStyle16Bold,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onGalleryTap,
                splashColor: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.photo,
                      size: 60.h,
                      color: AppColors.purple,
                    ),
                    Text(
                      "Gallery",
                      style: kTextStyle16Bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

buildShowModalBottomSheetSignature(BuildContext context, Widget child) async {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return child;
      });
}

Future<String> saveSignatureFileReturnPath(
  String fileName,
  ByteData image,
) async {
  const directoryName = "SignatureGenerated";
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path;
  String finalPath = "$path/$directoryName/$fileName.png";
  await Directory('$path/$directoryName').create(recursive: true);
  File(finalPath).writeAsBytesSync(image.buffer.asInt8List());
  return finalPath;
}

Future<void> checkVersion(BuildContext context) async {
  try {
    final newVersion = NewVersion();
    final status = await newVersion.getVersionStatus();
    bool canUpdateCheck = status?.canUpdate ?? false;
    if (status != null && canUpdateCheck) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Update Available',
        dialogText: 'New update is available,\nkindly update.',
        updateButtonText: 'Update Now',
        dismissButtonText: 'Maybe Later',
        allowDismissal: false,
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error while checking version $e");
    }
  }
}

void customDialogWithChild({
  required BuildContext context,
  required Widget child,
}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 200.h,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kBorderRadius8),
          ),
          child: child,
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}

void customDialog({
  required BuildContext context,
  required String titleText,
  required String middleText,
  required Widget? afterTextWidget,
  required String buttonRightText,
  required String buttonLeftText,
  required VoidCallback buttonRightTextOnTap,
  required VoidCallback buttonLeftTextOnTap,
  required bool barrierDismissible,
  bool showLeftButton = true,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withOpacity(0.2),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 30.w),
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kBorderRadius4),
            boxShadow: kContainerShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText,
                style: kTextStyle12Normal,
              ),
              if (middleText.isNotEmpty)
                SizedBox(
                  height: 10.h,
                ),
              if (middleText.isNotEmpty)
                Text(
                  middleText,
                  style: kTextStyle11Normal.copyWith(
                    color: AppColors.secondary,
                    letterSpacing: 0.5,
                  ),
                ),
              if (afterTextWidget != null)
                SizedBox(
                  height: 20.h,
                ),
              if (afterTextWidget != null) afterTextWidget,
              SizedBox(
                height: afterTextWidget != null ? 20.h : 40.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (showLeftButton)
                    TextButton(
                      onPressed: buttonLeftTextOnTap,
                      child: Text(
                        buttonLeftText.toUpperCase(),
                        style:
                            kTextStyle12Bold.copyWith(color: AppColors.primary),
                      ),
                    ),
                  if (showLeftButton)
                    SizedBox(
                      width: 10.w,
                    ),
                  TextButton(
                    onPressed: buttonRightTextOnTap,
                    child: Text(
                      buttonRightText.toUpperCase(),
                      style:
                          kTextStyle12Bold.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}

void customDialogForVisitStartConfirmation({
  required BuildContext context,
  required VoidCallback buttonConfirmOnTap,
  required VoidCallback buttonConfirmAndOpenMapOnTap,
  required VoidCallback buttonCancelOnTap,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kBorderRadius4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.confirmation,
                style: kTextStyle14Normal,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                AppTexts.visitConfirmationText,
                style: kTextStyle12Normal.copyWith(
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              CustomLargeButton(
                onPressed: buttonConfirmOnTap,
                title: AppTexts.confirm.toUpperCase(),
                bgColor: AppColors.success,
                textColor: AppColors.white,
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomLargeButton(
                onPressed: buttonConfirmAndOpenMapOnTap,
                title: AppTexts.confirmAndMap.toUpperCase(),
                bgColor: AppColors.primary,
                textColor: AppColors.white,
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomLargeButton(
                onPressed: buttonCancelOnTap,
                title: AppTexts.cancel.toUpperCase(),
                bgColor: AppColors.white,
                textColor: AppColors.secondary,
                borderColor: AppColors.secondary,
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}

Future<DateTime?> pickDateAndAssign(
    BuildContext context, bool startFromToday, bool endDateToday) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: startFromToday ? DateTime.now() : DateTime(1900, 1),
      lastDate: endDateToday ? DateTime.now() : DateTime(2101));
  if (picked != null) {
    return picked;
  } else {
    return null;
  }
}

void launchSendSMS(String message, List<String> recipents) async {
  String _result = await sendSMS(message: message, recipients: recipents)
      .catchError((onError) {
    print(onError);
  });
  print(_result);
}

launchCaller(String number) async {
  Uri url = Uri(
    scheme: 'tel',
    path: number,
  );
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
    print("reached 1: ");
  } else {
    if (kDebugMode) {
      print('Could not open dialog for number = $url');
      print("reached 1: ");
    }
  }
}

launchUrlFromUri(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    if (kDebugMode) {
      print('Could not open this url = $url');
    }
  }
}

Future<String> downloadFile(
  String url,
) async {
  HttpClient httpClient = HttpClient();
  File file;
  String filePath = '';
  String fileName = url.substring(url.lastIndexOf('/') + 1, (url.length - 4));

  try {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      filePath = '$dir/$fileName';
      file = File(filePath);
      await file.writeAsBytes(bytes);
    } else {
      filePath = 'Error code: ${response.statusCode}';
    }
  } catch (ex) {
    filePath = 'Can not fetch url';
  }
  return filePath;
}

Future<String> getDeviceModel() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.model;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.utsname.machine ?? "";
  } else {
    return "";
  }
}

Future<bool> checkTodayDateIsBetween(
    DateTime startDate, DateTime endDate) async {
  print(compareTwoDateOnly(DateTime.now(), startDate));
  print(compareTwoDateOnly(DateTime.now(), endDate));

  if (compareTwoDateOnly(DateTime.now(), startDate) ||
      compareTwoDateOnly(DateTime.now(), endDate) ||
      (DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate))) {
    return true;
  } else {
    return false;
  }
}

bool compareTwoDateOnly(DateTime first, DateTime second) {
  if (first.year == second.year &&
      first.month == second.month &&
      first.day == second.day) {
    return true;
  } else {
    return false;
  }
}

String returnRandomStringNumber() {
  Random random = Random();
  int randomNumber = random.nextInt(9999999) + random.nextInt(100000000);
  return randomNumber.toString();
}

String returnSizeOfImageInMb(File file) {
  int sizeInBytes = file.lengthSync();
  double sizeInMb = sizeInBytes / (1024 * 1024);
  print("Size of ${file.path} = $sizeInMb");
  return sizeInMb.toString();
}

Future<bool> checkVisitScheduledDate(JobController jobController) async {
  String? startDate = jobController.selectedJob['start_date'];
  String? endDate = jobController.selectedJob['end_date'];
  startDate ??= "";
  endDate ??= "";
  bool temp = startDate.isEmpty ||
      endDate.isEmpty ||
      await checkTodayDateIsBetween(
        DateTime(
            int.parse(startDate.substring(6)),
            int.parse(startDate.substring(0, 2)),
            int.parse(startDate.substring(3, 5))),
        DateTime(
            int.parse(endDate.substring(6)),
            int.parse(endDate.substring(0, 2)),
            int.parse(endDate.substring(3, 5))),
      );
  return temp;
}

showVisitCannotStartDueToDate(BuildContext context) {
  customDialog(
    context: context,
    barrierDismissible: false,
    titleText: AppTexts.startTravelling,
    middleText: AppTexts.startTravellingFailDueToDate,
    afterTextWidget: null,
    showLeftButton: false,
    buttonLeftText: "",
    buttonLeftTextOnTap: () {
      Get.back(closeOverlays: true);
    },
    buttonRightText: AppTexts.ok,
    buttonRightTextOnTap: () {
      Get.back(closeOverlays: true);
    },
  );
}

Future<bool> checkLocationPermissionAndAskForLocation(
    BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Mobile location is off.
    Util.showErrorSnackBar("Mobile Location is Off");
    customDialog(
      context: context,
      titleText: AppTexts.permissionRequired,
      middleText: AppTexts.locationPermissionCompulsoryConfirmation,
      afterTextWidget: null,
      buttonRightText: AppTexts.enable,
      buttonLeftText: AppTexts.cancel,
      buttonRightTextOnTap: () async {
        if (await Geolocator.isLocationServiceEnabled() == false) {
          await Geolocator.openLocationSettings();
        } else {
          Get.back(closeOverlays: true);
        }
      },
      buttonLeftTextOnTap: () {
        SystemNavigator.pop(animated: true);
      },
      barrierDismissible: false,
    );
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    Util.showErrorSnackBar(
        "Location permission is denied, Asking for permission");
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Util.showErrorSnackBar("Location permission is Again denied.");
      return false;
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition();
      Util.showToast(
          "latitude = ${position.latitude}\nlongitude = ${position.longitude}");
      return true;
    } else {
      return false;
    }
  } else if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    Position position = await Geolocator.getCurrentPosition();
    Util.showToast(
        "latitude = ${position.latitude}\nlongitude = ${position.longitude}");
    return true;
  }

  if (permission == LocationPermission.deniedForever) {
    Util.showErrorSnackBar("Location permission is Forever denied.");
    return false;
  } else {
    return false;
  }
}
