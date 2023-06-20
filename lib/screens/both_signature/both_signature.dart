import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/screens/components/custom_app_bar.dart';
import 'package:easy_certs/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../controller/auth_controller.dart';
import '../../utils/extra_function.dart';
import '../../utils/util.dart';

class BothSignature extends StatelessWidget {
  BothSignature({Key? key}) : super(key: key);
  GlobalKey<SfSignaturePadState> customerSignatureKey = GlobalKey();
  GlobalKey<SfSignaturePadState> engineerSignatureKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppbar(
          displayLeading: true,
          title: AppTexts.agreeToTerms,
          centerTitle: false,
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          action: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: IconButton(
                onPressed: () async {
                  if (customerSignatureKey.currentState != null &&
                      engineerSignatureKey.currentState != null) {
                    Util.showLoading("Updating");
                    ui.Image customerImage =
                        await customerSignatureKey.currentState!.toImage();
                    ui.Image engineerImage =
                        await engineerSignatureKey.currentState!.toImage();
                    ByteData? customerByteData = await customerImage.toByteData(
                      format: ui.ImageByteFormat.png,
                    );
                    ByteData? engineerByteData = await engineerImage.toByteData(
                      format: ui.ImageByteFormat.png,
                    );
                    String customerPath = "", engineerPath = "";
                    String customerPathName = returnRandomStringNumber(),
                        engineerPathName = returnRandomStringNumber();
                    if (customerByteData != null) {
                      customerPath = await saveSignatureFileReturnPath(
                          customerPathName, customerByteData);
                    }
                    if (engineerByteData != null) {
                      engineerPath = await saveSignatureFileReturnPath(
                          engineerPathName, engineerByteData);
                    }
                    AuthController authController = Get.find();
                    bool temp1 = false, temp2 = false;
                    if (customerPath.isNotEmpty) {
                      temp1 = await jobController.eventAddUploadSignature(
                        false,
                        customerPath,
                        authController.userModel.value.id.toString(),
                        authController.userModel.value.id.toString().isEmpty ||
                                authController.userModel.value.id.toString() ==
                                    'null'
                            ? "0"
                            : authController.userModel.value.id.toString(),
                        true,
                        jobController.selectedJob['id'].toString(),
                        "${jobController.selectedJob['customer']['name']} Signature",
                        authController.token.value,
                        "$customerPathName.png",
                        returnSizeOfImageInMb(
                          File(customerPath),
                        ),
                      );
                    }
                    if (engineerPath.isNotEmpty) {
                      temp2 = await jobController.eventAddUploadSignature(
                        true,
                        engineerPath,
                        authController.userModel.value.id.toString(),
                        authController.userModel.value.id.toString().isEmpty ||
                                authController.userModel.value.id.toString() ==
                                    'null'
                            ? "0"
                            : authController.userModel.value.id.toString(),
                        true,
                        jobController.selectedJob['id'].toString(),
                        "${authController.userModel.value.name} Signature",
                        authController.token.value,
                        "$engineerPathName.png",
                        returnSizeOfImageInMb(
                          File(engineerPath),
                        ),
                      );
                    }

                    if (temp1 && temp2) {
                      bool temp3 = await jobController.jobVisitComplete(
                        jobController.selectedJob['id'].toString(),
                        jobController.selectedJob['job_id'].toString(),
                        "1",
                        //Todo implement WorkTime for now it is Hardcoded
                        "0",
                        "1",
                        jobController.engSignatureUrl.value,
                        jobController.customerSignatureUrl.value,
                      );
                      if (temp3 == false) {
                        Util.dismiss();
                      }
                    } else {
                      Util.dismiss();
                    }
                  } else {
                    Util.showErrorSnackBar("Sign on both fields");
                  }
                },
                splashRadius: 20.h,
                icon: const Icon(
                  Icons.check,
                  color: AppColors.black,
                ),
              ),
            )
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      AppTexts.customerSignature,
                      style: kTextStyle14Bold,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Expanded(
                      child: Card(
                        elevation: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              AppTexts.agreeToTermAndConditions,
                              style: kTextStyle10Normal.copyWith(
                                  color: AppColors.red),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: AppColors.grey300,
              thickness: 3.h,
              height: 20.h,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      AppTexts.engineerSignature,
                      style: kTextStyle14Bold,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Expanded(
                      child: Card(
                        elevation: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: SfSignaturePad(
                                key: engineerSignatureKey,
                                minimumStrokeWidth: 1,
                                maximumStrokeWidth: 3,
                                strokeColor: Colors.black,
                                backgroundColor: AppColors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              AppTexts.agreeToTermAndConditions,
                              style: kTextStyle10Normal.copyWith(
                                  color: AppColors.red),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      );
    });
  }
}
