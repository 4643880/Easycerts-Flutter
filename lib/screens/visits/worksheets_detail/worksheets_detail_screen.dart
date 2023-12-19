import 'dart:convert';
import 'dart:developer';
import 'package:easy_certs/config/routes.dart';
import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/hive_boxes.dart';
import 'package:easy_certs/utils/extra_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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

class _WorksheetsDetailScreenState extends State<WorksheetsDetailScreen>
    with AutomaticKeepAliveClientMixin {
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

  dynamic myData;
  List<dynamic> temporaryList = [];
  getDataFromLocalStorage({required bool isLoading}) async {
    isLoading == true ? Util.showLoading("Please wait...") : null;
    temporaryList.clear();
    await funcToFechData();
    await Future.delayed(const Duration(seconds: 1));
    // devtools.log("2: " + DateTime.now().toString());
    setState(() {
      myData = temporaryList;
    });
    isLoading == true ? Util.dismiss() : null;
  }

  Future funcToFechData() async {
    List? listOfKeys = await Boxes.getKeysOfWorkSpaceData().get('keysOfList');
    // devtools.log(Boxes.getSavedWorkSpaceData().get(listOfKeys![0]).toString());
    listOfKeys?.forEach((element) async {
      final eachElement = await Boxes.getSavedWorkSpaceData().get(element);
      // devtools.log(eachElement.toString());
      if (eachElement["selectedJobId"] ==
          Get.find<JobController>().selectedJob["id"]) {
        temporaryList.add(eachElement);
      }
      // devtools.log("1: " + DateTime.now().toString());
    });
  }

  dynamic mySubmittedData;
  List<dynamic> temporaryList1 = [];
  getSubmittedDataFromLocalStorage({
    required bool isLoading,
    required bool isLoadingIssueDueToUpdate,
  }) async {
    isLoading == true ? Util.showLoading("Please wait...") : null;
    temporaryList1.clear();
    await funcToFechSubmittedData();
    await Future.delayed(const Duration(seconds: 1));
    // devtools.log("2: " + DateTime.now().toString());
    isLoadingIssueDueToUpdate == true
        ? null
        : setState(() {
            mySubmittedData = temporaryList1;
          });
    isLoading == true ? Util.dismiss() : null;
  }

  Future funcToFechSubmittedData() async {
    List? listOfKeys =
        await Boxes.getKeysOfSubmittedWorkSpaceData().get('keysOfList');
    // devtools.log(Boxes.getSavedWorkSpaceData().get(listOfKeys![0]).toString());
    listOfKeys?.forEach((element) async {
      final eachElement = await Boxes.getSubmittedWorkSpaceData().get(element);
      // devtools.log(eachElement.toString());
      if (eachElement["selectedJobId"] ==
          Get.find<JobController>().selectedJob["id"]) {
        temporaryList1.add(eachElement);
      }
      // devtools.log("each Element: " + eachElement.toString());
    });
  }

  @override
  void initState() {
    setState(() {
      getDataFromLocalStorage(isLoading: true);
      getSubmittedDataFromLocalStorage(
          isLoading: true, isLoadingIssueDueToUpdate: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        formKey.currentState!.save();
        return true;
      },
      child: GetBuilder<JobController>(builder: (jobController) {
        // devtools
        //     .log(jobController.selectedWorksheet["is_submitted"].toString());
        // devtools
        //     .log(jobController.selectedWorksheet['form_builder_json'].toString());
        // devtools.log("================> " + mySubmittedData.toString());
        // devtools
        //     .log("alpha:" + Get.find<JobController>().selectedJob.toString());
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              jobController.selectedWorksheet['name'],
            ),
          ),
          bottomSheet: jobController.selectedWorksheet["is_submitted"] == false
              ? null
              : BottomSheetTwoButton(
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

                    final list = [
                      ...jobController.worksheetDataSubmitModelList
                    ];
                    Map<dynamic, dynamic> tempData =
                        jsonDecode(jsonEncode(selectedWorkSheet))
                            as Map<dynamic, dynamic>;
                    // final listOfFormBuilderJson = jsonDecode(
                    //         jsonEncode(selectedWorkSheet["form_builder_json"]))
                    //     as List;
                    for (var e1 in tempData["form_builder_json"]) {
                      List formDataList = e1["data"];
                      for (var e2 in formDataList) {
                        List data = e2["data"];
                        for (var e3 in data) {
                          for (var e4 in list) {
                            if (e3["key"] == e4.f_name &&
                                e3["type"] == e4.f_type) {
                              e3["default"] = e4.f_value;
                            }
                          }
                        }
                      }
                    }

                    // devtools.log(selectedWorkSheet.toString());

                    // var uuid = const Uuid().v1();
                    List? emptyList = [];
                    emptyList =
                        Boxes.getKeysOfWorkSpaceData().get('keysOfList') ?? [];
                    if (emptyList!.contains(workSheetIdentifier)) {
                      emptyList.remove(workSheetIdentifier);
                    }
                    emptyList.add(workSheetIdentifier);
                    Boxes.getKeysOfWorkSpaceData().put('keysOfList', emptyList);

                    // await Boxes.getSavedWorkSpaceData().put(workSheetIdentifier, {
                    //   "selectedJobId": selectedJobId,
                    //   "workSheetIdentifier": workSheetIdentifier,
                    //   "worksheetData": selectedWorkSheet,
                    // });

                    final gettingData =
                        Boxes.getSavedWorkSpaceData().get(workSheetIdentifier);
                    if (gettingData == null) {
                      devtools.log("=> Dont have data");

                      await Boxes.getSavedWorkSpaceData()
                          .put(workSheetIdentifier, {
                        "selectedJobId": selectedJobId,
                        "workSheetIdentifier": workSheetIdentifier,
                        "worksheetData": tempData,
                      });
                    } else {
                      devtools.log("=> Already have data");
                      await Boxes.getSavedWorkSpaceData()
                          .delete(workSheetIdentifier);
                      await Boxes.getSavedWorkSpaceData()
                          .put(workSheetIdentifier, {
                        "selectedJobId": selectedJobId,
                        "workSheetIdentifier": workSheetIdentifier,
                        "worksheetData": tempData,
                      });
                    }

                    final data = await Boxes.getSavedWorkSpaceData()
                        .get(workSheetIdentifier);
                    // devtools.log(data.toString());

                    // List? listOfKeys = Boxes.getKeysOfWorkSpaceData().get('keysOfList');

                    // devtools.log(listOfKeys.toString());

                    // ===========================
                    // Deleting From Local Storage
                    // List keys =
                    //     Boxes.getKeysOfWorkSpaceData().get('keysOfList');
                    // for (final value in keys) {
                    //   await Boxes.getSavedWorkSpaceData().delete(value);
                    // }
                    // await Boxes.getKeysOfWorkSpaceData().delete('keysOfList');
                    // devtools.log(keys.toString());

                    // ===========================

                    await Future.delayed(const Duration(seconds: 1), () {
                      formKey.currentState!.reset();
                    });

                    jobController.selectedWorksheet = {}.obs;
                    jobController.updateSelectedWorksheet(tempList[0]);

                    await getDataFromLocalStorage(isLoading: false);
                    Get.back();
                    Util.dismiss();
                    setState(() {});
                  },
                  onPressed2: () async {
                    Util.showLoading("Please wait...");
                    AuthController authController = Get.find();
                    Get.find<JobController>()
                        .listToCollectValidationErrorsModel
                        .clear();
                    if (formKey.currentState!.validate()) {
                      WorksheetImageRenderedModel? checkImageIsRequired =
                          jobController.worksheetImageRenderedList
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
                        bool imageUploadCheck =
                            await jobController.uploadFormImagesWithApi(
                          authController.token.value,
                          isLoadingIssueDueToUpdate: true,
                        );

                        if (imageUploadCheck) {
                          bool signatureUploadCheck =
                              await jobController.uploadFormSignatureWithApi(
                            authController.token.value,
                            isLoadingIssueDueToUpdate: true,
                          );
                          if (signatureUploadCheck) {
                            jobController.clearWorksheetDataSubmitModelList(
                              isLoadingIssueDueToUpdate: true,
                            );

                            await Future.delayed(const Duration(seconds: 1),
                                () {
                              formKey.currentState!.save();
                            });

                            await Future.delayed(const Duration(seconds: 1))
                                .whenComplete(() async {
                              Util.showLoading("Please wait...");
                            });

                            //TODO change JobID
                            bool temp =
                                await jobController.submitWorkSheetWithApi(
                              jobController.selectedWorksheet['identifier'],
                              authController.token.toString(),
                              jobController.selectedJob['id'],
                              jobController.worksheetDataSubmitModelList,
                              isLoadingIssueDueToUpdate: true,
                            );

                            if (temp) {
                              await jobController
                                  .deleteAllSignatureFromDevice();

                              jobController.selectedWorksheet["is_submitted"] =
                                  true;

                              await saveSubmittedWorkSheet(
                                jobController,
                                isLoading: false,
                                isLoadingIssueDueToUpdate: true,
                              );
                              Util.dismiss();
                              jobController.update();
                              Get.back();
                              Util.showSnackBar(
                                "WorkSheet",
                                "WorkSheet Submitted Successfully.",
                                "",
                              );
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

                      Map<String, List<String>> resultMap = {};
                      List<Map> li = Get.find<JobController>()
                          .listToCollectValidationErrorsModel;

                      // Adding this map into validator function
                      // Map<String, Object> myMap = {
                      //   "expandedTileName": widget.expandedTileName,
                      //   "title": widget.title,
                      // };

                      for (var map in li) {
                        var expandedTileName = map["expandedTileName"];
                        var title = map["title"];
                        // devtools.log("expandedTileName => " + expandedTileName);
                        // devtools.log("title => " + title);

                        if (resultMap.containsKey(expandedTileName)) {
                          resultMap[expandedTileName]!.add(title);
                          // devtools.log("${resultMap[expandedTileName]}");
                          // devtools.log("${expandedTileName}");
                        } else {
                          resultMap[expandedTileName] = [title];
                        }
                      }

                      // devtools.log("after for loop => ${resultMap.toString()}");

                      List<Map<String, dynamic>> desiredOutput =
                          resultMap.entries
                              .map((entry) => {
                                    "Expanded Tile Name": entry.key,
                                    "List of Errors": entry.value,
                                  })
                              .toList();

                      // devtools.log("desired Output : " + desiredOutput.toString());
                      //
                      Get.find<JobController>()
                          .listToCollectValidationErrorsModel
                          .value = desiredOutput;

                      customDialogForValidationError(
                        context: context,
                        barrierDismissible: false,
                        buttonCancelOnTap: () {
                          Get.back();
                        },
                        buttonConfirmAndOpenMapOnTap: () {},
                        buttonConfirmOnTap: () {},
                        validationErrorsList: Get.find<JobController>()
                            .listToCollectValidationErrorsModel,
                      );
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
                                  (jobController
                                          .selectedWorksheet['pageCount'] -
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
                  // height: 670.h,
                  height:
                      jobController.selectedWorksheet["is_submitted"] == true
                          ? 620.h
                          : 570.h,
                  // color: Colors.red,
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
                              addAutomaticKeepAlives: true,
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
                                    sectionData:
                                        jobController.selectedWorksheet[
                                                'form_builder_json'][index]
                                            ['data'][subIndex],
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
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> saveSubmittedWorkSheet(
    JobController jobController, {
    required bool isLoading,
    required bool isLoadingIssueDueToUpdate,
  }) async {
    isLoading == true ? Util.showLoading("Please wait...") : null;
    final selectedJobId = jobController.selectedJob['id'];
    Map<dynamic, dynamic> selectedWorkSheet = jobController.selectedWorksheet;
    final workSheetIdentifier = selectedWorkSheet['identifier'];

    final tempList = [];
    tempList.add(selectedWorkSheet);

    final list = [...jobController.worksheetDataSubmitModelList];

    final listOfFormBuilderJson = [
      ...selectedWorkSheet["form_builder_json"] as List
    ];
    Map<dynamic, dynamic> tempData =
        jsonDecode(jsonEncode(selectedWorkSheet)) as Map<dynamic, dynamic>;
    for (var e1 in tempData["form_builder_json"]) {
      List formDataList = e1["data"];
      for (var e2 in formDataList) {
        List data = e2["data"];
        for (var e3 in data) {
          for (var e4 in list) {
            if (e3["key"] == e4.f_name && e3["type"] == e4.f_type) {
              e3["default"] = e4.f_value;
            }
          }
        }
      }
    }

    // devtools.log(selectedWorkSheet.toString());

    // var uuid = const Uuid().v1();
    List? emptyList = [];
    emptyList =
        await Boxes.getKeysOfSubmittedWorkSpaceData().get('keysOfList') ?? [];
    if (emptyList!.contains(workSheetIdentifier)) {
      emptyList.remove(workSheetIdentifier);
    }
    emptyList.add(workSheetIdentifier);
    await Boxes.getKeysOfSubmittedWorkSpaceData().put('keysOfList', emptyList);

    // await Boxes.getSavedWorkSpaceData().put(workSheetIdentifier, {
    //   "selectedJobId": selectedJobId,
    //   "workSheetIdentifier": workSheetIdentifier,
    //   "worksheetData": selectedWorkSheet,
    // });

    final gettingData =
        await Boxes.getSubmittedWorkSpaceData().get(workSheetIdentifier);
    if (gettingData == null) {
      await Boxes.getSubmittedWorkSpaceData().put(workSheetIdentifier, {
        "selectedJobId": selectedJobId,
        "workSheetIdentifier": workSheetIdentifier,
        "worksheetData": tempData,
      });
    } else {
      await Boxes.getSubmittedWorkSpaceData().delete(workSheetIdentifier);
      await Boxes.getSubmittedWorkSpaceData().put(workSheetIdentifier, {
        "selectedJobId": selectedJobId,
        "workSheetIdentifier": workSheetIdentifier,
        "worksheetData": tempData,
      });
    }

    final data =
        await Boxes.getSubmittedWorkSpaceData().get(workSheetIdentifier);
    // devtools.log(data.toString());

    // List? listOfKeys = Boxes.getKeysOfWorkSpaceData().get('keysOfList');

    // devtools.log(listOfKeys.toString());

    // ===========================
    // Deleting From Local Storage
    // List keys = Boxes.getKeysOfWorkSpaceData().get('keysOfList');
    // for (final value in keys) {
    //   await Boxes.getSavedWorkSpaceData().delete(value);
    // }
    // Boxes.getKeysOfWorkSpaceData().delete('keysOfList');
    // devtools.log(keys.toString());

    // ===========================

    await Future.delayed(const Duration(seconds: 1), () {
      formKey.currentState!.reset();
    });

    await Future.delayed(const Duration(seconds: 1)).whenComplete(() async {
      Util.showLoading("Please wait...");
    });

    jobController.selectedWorksheet = {}.obs;
    jobController.updateSelectedWorksheet(
      tempList[0],
      true,
    );

    await getSubmittedDataFromLocalStorage(
      isLoading: true,
      isLoadingIssueDueToUpdate: true,
    );

    isLoading == true ? Util.showLoading("Please wait...") : null;
  }
}
