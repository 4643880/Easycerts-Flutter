import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/screens/components/custom_app_bar.dart';
import 'package:easy_certs/screens/components/custom_divider.dart';
import 'package:easy_certs/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import '../../utils/extra_function.dart';
import '../../utils/util.dart';
import '../components/bottom_sheet_button.dart';
import '../components/custom_dialog_tick.dart';
import '../components/custom_two_text.dart';
import '../components/input_with_inner_label.dart';

class VisitCheckout extends StatefulWidget {
  VisitCheckout({Key? key}) : super(key: key);

  @override
  State<VisitCheckout> createState() => _VisitCheckoutState();
}

class _VisitCheckoutState extends State<VisitCheckout> {
  RxBool proceedToInvoice = false.obs;
  RxString additionalComment = "".obs;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getDataReady();
    super.initState();
  }

  getDataReady() async {
    Util.showLoading("Fetching Data");
    JobController jobController = Get.find();
    AuthController authController = Get.find();
    if (jobController.selectedJob['job_id'] != null &&
        jobController.selectedJob['job_id'].toString().isNotEmpty) {
      bool temp = await jobController.getCheckoutJobDetail(
        jobController.selectedJob['job_id'].toString(),
        authController.token.value,
      );
      if (temp) {
        Util.dismiss();
      } else {
        Util.dismiss();
      }
    } else {
      Util.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
      return Scaffold(
        appBar: CustomAppbar(
          displayLeading: true,
          title: "Checkout",
          centerTitle: false,
        ),
        bottomSheet: BottomSheetButton(
          buttonTitle: AppTexts.collectPayment,
          bgColor: AppColors.success,
          borderColor: AppColors.success,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              customDialog(
                context: context,
                barrierDismissible: false,
                titleText: AppTexts.payment,
                middleText: AppTexts.makeJobPaymentConfirmation,
                afterTextWidget: null,
                buttonLeftText: AppTexts.cancel,
                buttonLeftTextOnTap: () {
                  Get.back(closeOverlays: true);
                },
                buttonRightText: AppTexts.yes,
                buttonRightTextOnTap: () async {
                  Get.back(closeOverlays: true);
                  Util.showLoading("Checking");
                  bool temp = await jobController.jobVisitCompleteFromCheckout(
                    jobController.selectedJob['job_id'].toString(),
                    "1",
                    additionalComment.value,
                    proceedToInvoice.value,
                    //Hardcoded value after asking Sir.
                    "0",
                    "0",
                  );
                  if (temp) {
                    Util.dismiss();
                    customDialog(
                      context: context,
                      barrierDismissible: false,
                      titleText: AppTexts.paymentSuccessful,
                      middleText: "",
                      afterTextWidget: const CustomDialogTick(),
                      showLeftButton: false,
                      buttonLeftText: "",
                      buttonLeftTextOnTap: () {},
                      buttonRightText: AppTexts.okay,
                      buttonRightTextOnTap: () async {
                        Get.back(closeOverlays: true);
                        Get.offNamed(routeDashboard);
                      },
                    );
                  } else {
                    Util.dismiss();
                  }
                },
              );
            }
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppTexts.proceedToInvoice,
                        style: kTextStyle14Bold,
                      ),
                      const Spacer(),
                      Obx(
                        () => Switch(
                          value: proceedToInvoice.value,
                          activeColor: AppColors.primary,
                          activeTrackColor: AppColors.primary.withOpacity(0.6),
                          onChanged: (value) {
                            proceedToInvoice.value = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InputWithInnerLabel(
                    labelText: "Additional Comment",
                    maxLines: 5,
                    onSaved: (String? newValue) {
                      if (newValue != null) {
                        additionalComment.value = newValue;
                      }
                    },
                    validator: (String? value) {
                      return simpleValidator(
                          value, "*Additional Comment is required");
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomTwoText(
                    first: AppTexts.timeToReachSite,
                    second: "00 min : 00 sec",
                    applyFlex: false,
                    applyPadding: false,
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  CustomTwoText(
                    first: AppTexts.workTime,
                    second: "00 min : 00 sec",
                    applyFlex: false,
                    applyPadding: false,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  const CustomDivider(),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    AppTexts.paymentDetail,
                    style: kTextStyle14Bold,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  if (jobController.checkoutJobsDetail['advance'] != null &&
                      jobController.checkoutJobsDetail['advance']
                          .toString()
                          .isNotEmpty)
                    CustomTwoText(
                      first: AppTexts.advanceBalance,
                      second:
                          "${AppTexts.currency} ${jobController.checkoutJobsDetail['advance']}",
                      applyFlex: false,
                      applyPadding: false,
                    ),
                  SizedBox(
                    height: 14.h,
                  ),
                  if (jobController.checkoutJobsDetail['balance'] != null &&
                      jobController.checkoutJobsDetail['balance']
                          .toString()
                          .isNotEmpty)
                    CustomTwoText(
                      first: AppTexts.balanceDue,
                      second:
                          "${AppTexts.currency} ${jobController.checkoutJobsDetail['balance']}",
                      applyFlex: false,
                      applyPadding: false,
                    ),
                  SizedBox(
                    height: 14.h,
                  ),
                  if (jobController.checkoutJobsDetail['total'] != null &&
                      jobController.checkoutJobsDetail['total']
                          .toString()
                          .isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${AppTexts.currency} ${jobController.checkoutJobsDetail['total']}",
                        textAlign: TextAlign.end,
                        style: kTextStyle12Normal.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
