import 'dart:io';

import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/controller/notes_controller.dart';
import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/screens/components/large_button.dart';
import 'package:easy_certs/utils/extra_function.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'dart:developer' as devtools show log;

class TypeSignatureScreen extends StatelessWidget {
  GlobalKey<SfSignaturePadState> customerSignatureKey = GlobalKey();
  RxString customPath = "".obs;
  TypeSignatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text("Easy Certs"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.rotate_left),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.rotate_right),
            ),
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: SfSignaturePad(
                  key: customerSignatureKey,
                  minimumStrokeWidth: 1,
                  maximumStrokeWidth: 3,
                  strokeColor: Colors.black,
                  backgroundColor: AppColors.white,
                ),
              ),
              // Obx(
              //   () => Expanded(
              //     child: Container(
              //       child: Image.file(
              //         File(customPath.value),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(32.0),
          child: CustomLargeButton(
            onPressed: () async {
              ui.Image customImage =
                  await customerSignatureKey.currentState!.toImage();

              ByteData? customByteData = await customImage.toByteData(
                format: ui.ImageByteFormat.png,
              );

              String customPathName = returnRandomStringNumber();
              if (customByteData != null) {
                customPath.value = await saveSignatureFileReturnPath(
                    customPathName, customByteData);
              }
              if (customPath.isNotEmpty) {
                // devtools.log(customPath.value);
                Util.showLoading("Uploading Signature...");
                final response =
                    await Get.find<NotesController>().uploadSignatureOfNote(
                  jobId: Get.find<JobController>().selectedJob["id"].toString(),
                  token: Get.find<AuthController>().token.value,
                  type: 6,
                  imageFile: File(customPath.value),
                );
                if (response != null && response["data"] != null) {
                  Get.find<JobController>().listOfSelectedJobNotes.insert(
                    0,
                    {
                      "jobId": Get.find<JobController>()
                          .selectedJob["id"]
                          .toString(),
                      "url": response["data"]["url"],
                      "type": "image",
                    },
                  );
                }
              }
              Util.dismiss();
            },
            title: "Submit",
            bgColor: AppColors.success,
            textColor: AppColors.white,
          ),
        ),
      ),
    );
  }
}
