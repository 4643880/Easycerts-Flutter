import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/screens/components/bottom_sheet_button.dart';
import 'package:easy_certs/screens/components/custom_app_bar.dart';
import 'package:easy_certs/screens/components/input_with_inner_label.dart';
import 'package:easy_certs/utils/extra_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../helper/app_colors.dart';
import '../../utils/util.dart';

class NoAccess extends StatefulWidget {
  const NoAccess({Key? key}) : super(key: key);

  @override
  State<NoAccess> createState() => _NoAccessState();
}

class _NoAccessState extends State<NoAccess> {
  List<String> items = [], itemsDescription = [], itemsID = [];
  String? dropdownValue, commentText;
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getListReady();
    super.initState();
  }

  getListReady() {
    Util.showLoading("Loading");
    JobController jobController = Get.find();
    if (jobController.templates[AppTexts.tempNoAccess] != null &&
        jobController.templates[AppTexts.tempNoAccess].isNotEmpty) {
      for (int i = 0;
          i < jobController.templates[AppTexts.tempNoAccess].length;
          i++) {
        if (jobController.templates[AppTexts.tempNoAccess][i]['status']
                .toString() ==
            "1") {
          itemsID.add(
              jobController.templates[AppTexts.tempNoAccess][i]['id'] != null
                  ? jobController.templates[AppTexts.tempNoAccess][i]['id']
                      .toString()
                  : "");
          items.add(
              jobController.templates[AppTexts.tempNoAccess][i]['title'] ?? "");
          itemsDescription.add(jobController.templates[AppTexts.tempNoAccess][i]
                  ['description'] ??
              " ");
        }
      }
      Util.dismiss();
    } else {
      Util.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
      return Scaffold(
        appBar: CustomAppbar(
          title: AppTexts.noAccess,
          centerTitle: false,
          displayLeading: true,
        ),
        bottomSheet: BottomSheetButton(
          buttonTitle: AppTexts.submit,
          borderColor: AppColors.success,
          bgColor: AppColors.success,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              customDialog(
                context: context,
                titleText: AppTexts.cancelJob,
                middleText: AppTexts.cancelJobConfirmation,
                afterTextWidget: null,
                buttonRightText: AppTexts.yes,
                buttonLeftText: AppTexts.no,
                buttonRightTextOnTap: () async {
                  Get.back(closeOverlays: true);
                  Util.showLoading("Updating Status");
                  JobController jobController = Get.find();
                  AuthController authController = Get.find();
                  int index = items.indexOf(dropdownValue ?? "");
                  late bool temp;
                  if (index != -1) {
                    temp = await jobController.updateSelectedJobStatus(
                      jobController.selectedJob['id'].toString(),
                      "6",
                      jobController.selectedJob['status'].toString(),
                      itemsID[index],
                      commentText,
                      authController.token.value,
                    );
                  }
                  if (temp) {
                    Util.dismiss();
                    Get.back(closeOverlays: true);
                  } else {
                    Util.dismiss();
                  }
                },
                buttonLeftTextOnTap: () {
                  Get.back(closeOverlays: true);
                },
                barrierDismissible: false,
              );
            }
          },
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: "Reason",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6200EE)),
                      ),
                    ),
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                            )))
                        .toList(),
                    menuMaxHeight: 300.h,
                    elevation: 4,
                    alignment: AlignmentDirectional.centerStart,
                    onChanged: (dynamic newValue) {
                      setState(() {
                        if (newValue != null) {
                          int index = items.indexOf(newValue);
                          if (index != -1) {
                            dropdownValue = newValue;
                            controller.text = itemsDescription[index];
                          }
                        }
                      });
                    },
                    onSaved: (newValue) {
                      dropdownValue = newValue;
                    },
                    validator: (newValue) {
                      return simpleValidator(
                          newValue, "*Reason ${AppTexts.thisCannotBeEmpty}");
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InputWithInnerLabel(
                    controller: controller,
                    labelText: AppTexts.comment,
                    maxLines: 6,
                    onSaved: (newValue) {
                      commentText = newValue;
                    },
                    validator: (newValue) {
                      return simpleValidator(
                          newValue, "*Comment ${AppTexts.thisCannotBeEmpty}");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
