import 'dart:convert';
import 'dart:developer';
import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/helper/hive_boxes.dart';
import 'package:easy_certs/model/worksheet_data_submit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as devtools show log;
import '../../../model/worksheet_image_rendered_model.dart';
import '../../../utils/util.dart';
import '../../components/bottom_sheet_two_button.dart';
import '../../components/dynamic_expanded_tiles.dart';

class WorksheetsDetailScreen extends StatefulWidget {
  const WorksheetsDetailScreen({Key? key}) : super(key: key);

  @override
  State<WorksheetsDetailScreen> createState() => _WorksheetsDetailScreenState();
}

class _WorksheetsDetailScreenState extends State<WorksheetsDetailScreen> {
  PageController controller = PageController();
  RxInt currentPage = 0.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    JobController jobController = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      jobController.resetWorksheetControllerData();
    });
    super.dispose();
  }

  List myData = [];

  @override
  void initState() {
    getDataFromLocalStorage();
    super.initState();
  }

  List<dynamic> temporaryList = [];
  getDataFromLocalStorage() async {
    temporaryList.clear();
    await funcToFechData();
    await Future.delayed(const Duration(seconds: 1));
    // devtools.log("2: " + DateTime.now().toString());
    setState(() {
      myData = temporaryList;
    });
  }

  Future funcToFechData() async {
    List? listOfKeys = await Boxes.getKeysOfWorkSpaceData().get('keysOfList');
    // devtools.log(Boxes.getSavedWorkSpaceData().get(listOfKeys![0]).toString());
    listOfKeys?.forEach((element) async {
      final eachElement = await Boxes.getSavedWorkSpaceData().get(element);
      // devtools.log(eachElement.toString());
      temporaryList.add(eachElement);
      // devtools.log("1: " + DateTime.now().toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
      // devtools
      //     .log(jobController.selectedWorksheet['form_builder_json'].toString());
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            jobController.selectedWorksheet['name'],
          ),
        ),
        bottomSheet: BottomSheetTwoButton(
          onPressed: () async {
            Util.showLoading("Saving Data...");
            await Future.delayed(const Duration(seconds: 1), () {
              formKey.currentState!.save();
            });

            final selectedJobId = jobController.selectedJob['id'];
            Map<dynamic, dynamic> selectedWorkSheet =
                jobController.selectedWorksheet;
            final workSheetIdentifier = selectedWorkSheet['identifier'];

            final tempList = [];
            tempList.add(selectedWorkSheet);

            final list = jobController.worksheetDataSubmitModelList;

            final listOfFormBuilderJson =
                selectedWorkSheet["form_builder_json"] as List;
            for (var e1 in listOfFormBuilderJson) {
              List formDataList = e1["data"];
              for (var e2 in formDataList) {
                List data = e2["data"];
                for (var e3 in data) {
                  for (var e4 in list) {
                    if (e3["key"] == e4.f_name && e3["type"] == e4.f_type) {
                      e3["default"] = e4.f_value;
                      devtools.log(e3["default"].toString() +
                          "===" +
                          e4.f_value.toString());
                    }
                  }
                }
              }
            }

            var uuid = const Uuid().v1();
            List? emptyList = [];
            emptyList = Boxes.getKeysOfWorkSpaceData().get('keysOfList') ?? [];
            emptyList?.add(uuid);
            Boxes.getKeysOfWorkSpaceData().put('keysOfList', emptyList);

            await Boxes.getSavedWorkSpaceData().put(uuid, {
              "selectedJobId": selectedJobId,
              "workSheetIdentifier": workSheetIdentifier,
              "worksheetData": selectedWorkSheet,
            });

            List? listOfKeys = Boxes.getKeysOfWorkSpaceData().get('keysOfList');

            devtools.log(listOfKeys.toString());

            // ===========================
            // Deleting From Local Storage
            // listOfKeys?.forEach((element) {
            //   Boxes.getSavedWorkSpaceData().delete(element);
            // });
            // Boxes.getKeysOfWorkSpaceData().delete("keysOfList");
            // ===========================

            await Future.delayed(const Duration(seconds: 1), () {
              formKey.currentState!.reset();
            });

            jobController.selectedWorksheet = {}.obs;
            jobController.updateSelectedWorksheet(tempList[0]);

            await getDataFromLocalStorage();
            setState(() {});
            Get.back();
            Util.dismiss();
          },
          onPressed2: () async {
            Util.showLoading("Uploading Data");
            if (formKey.currentState!.validate()) {
              WorksheetImageRenderedModel? checkImageIsRequired = jobController
                  .worksheetImageRenderedList
                  .firstWhereOrNull((element) {
                if (element.isFilled == false) {
                  if (element.isRequired == true) {
                    Util.dismiss();
                    Util.showErrorSnackBar(
                        "${element.itemName} => ${element.expandedTitleName} => ${element.imageTitle} is required fields!");
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
              });

              WorksheetImageRenderedModel? checkSignatureIsRequired =
                  jobController.worksheetSignatureRenderedList
                      .firstWhereOrNull((element) {
                if (element.isFilled == false) {
                  if (element.isRequired == true) {
                    Util.dismiss();
                    Util.showErrorSnackBar(
                        "${element.itemName} => ${element.expandedTitleName} => ${element.imageTitle} is required fields!");
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
              });
              if (checkImageIsRequired == null &&
                  checkSignatureIsRequired == null) {
                AuthController authController = Get.find();
                bool imageUploadCheck = await jobController
                    .uploadFormImagesWithApi(authController.token.value);
                if (imageUploadCheck) {
                  bool signatureUploadCheck = await jobController
                      .uploadFormSignatureWithApi(authController.token.value);
                  if (signatureUploadCheck) {
                    jobController.clearWorksheetDataSubmitModelList();
                    await Future.delayed(const Duration(seconds: 1), () {
                      formKey.currentState!.save();
                    });
                    //TODO change JobID
                    bool temp = await jobController.submitWorkSheetWithApi(
                      jobController.selectedWorksheet['identifier'],
                      authController.token.toString(),
                      jobController.selectedJob['id'],
                      jobController.worksheetDataSubmitModelList,
                    );
                    if (temp) {
                      await jobController.deleteAllSignatureFromDevice();
                      Util.dismiss();
                      Get.back();
                    } else {
                      Util.dismiss();
                    }
                  } else {
                    Util.dismiss();
                    Util.showErrorSnackBar("Signature Uploading Fail!");
                  }
                } else {
                  Util.dismiss();
                  Util.showErrorSnackBar("Image Uploading Fail!");
                }
              }
            } else {
              Util.dismiss();
              Util.showErrorSnackBar("Some required fields are empty!");
            }
          },
          buttonTitle: "SAVE",
          buttonTitle2: "SUBMIT",
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Container(
                color: Colors.grey.shade400,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Obx(
                        () => Text(
                          jobController.selectedWorksheet['form_builder_json']
                              [currentPage.value]['name'],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (currentPage.value >= 1) {
                              currentPage.value = currentPage.value - 1;
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 20.sp,
                          ),
                          splashRadius: 20.r,
                        ),
                        Obx(
                          () => Text(
                              "${currentPage.value + 1}/${jobController.selectedWorksheet['pageCount']}"),
                        ),
                        IconButton(
                          onPressed: () {
                            log("count = ${jobController.selectedWorksheet['pageCount']}");
                            if (currentPage.value <
                                (jobController.selectedWorksheet['pageCount'] -
                                    1)) {
                              currentPage.value = currentPage.value + 1;
                            }
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 20.sp,
                          ),
                          splashRadius: 20.r,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 570.h,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Obx(
                  () => Form(
                    key: formKey,
                    child: IndexedStack(
                      index: currentPage.value,
                      children: jobController
                          .selectedWorksheet['form_builder_json']
                          .map<Widget>(
                        (e) {
                          int index = jobController
                              .selectedWorksheet['form_builder_json']
                              .indexOf(e);
                          return ListView(
                            shrinkWrap: true,
                            children: jobController
                                .selectedWorksheet['form_builder_json'][index]
                                    ['data']
                                .map<Widget>(
                              (e) {
                                int subIndex = jobController
                                    .selectedWorksheet['form_builder_json']
                                        [index]['data']
                                    .indexOf(e);
                                return DynamicExpandedTiles(
                                  index: subIndex,
                                  itemName: jobController.selectedWorksheet[
                                          'form_builder_json']
                                      [currentPage.value]['name'],
                                  sectionData: jobController.selectedWorksheet[
                                          'form_builder_json'][index]['data']
                                      [subIndex],
                                );
                              },
                            ).toList(),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
