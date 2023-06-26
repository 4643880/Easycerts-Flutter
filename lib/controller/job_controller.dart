import 'dart:developer';
import 'dart:io';

import 'package:easy_certs/model/validation_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/routes.dart';
import '../helper/app_texts.dart';
import '../model/worksheet_data_submit_model.dart';
import '../model/worksheet_image_rendered_model.dart';
import '../repository/job_repo.dart';
import '../screens/components/custom_dialog_tick.dart';
import '../utils/extra_function.dart';
import '../utils/util.dart';
import 'dart:developer' as devtools show log;

class JobController extends GetxController implements GetxService {
  RxBool isLoading = true.obs;
  RxList<dynamic> jobsList = [].obs;
  RxList<dynamic> listOfSearchedJobs = [].obs;
  RxList<dynamic> completedJobsList = [].obs;
  RxList<dynamic> pendingJobsList = [].obs;
  RxList<dynamic> onGoingJobsList = [].obs;
  RxList<dynamic> assignedJobsList = [].obs;
  RxString customerSignatureUrl = "".obs;
  RxString engSignatureUrl = "".obs;
  RxList<String> listToCollectValidationErrors = <String>[].obs;
  RxList<Map> listToCollectValidationErrorsModel = <Map>[].obs;
  RxList listOfSelectedJobNotes = [].obs;

  RxMap<String, dynamic> selectedJob = <String, dynamic>{}.obs;
  RxMap<String, dynamic> checkoutJobsDetail = <String, dynamic>{}.obs;
  RxMap<String, dynamic> templates = <String, dynamic>{}.obs;

  //For WorkSheets
  RxMap<dynamic, dynamic> selectedWorksheet = <dynamic, dynamic>{}.obs;
  RxList<WorksheetDataSubmitModel> worksheetDataSubmitModelList =
      <WorksheetDataSubmitModel>[].obs;
  RxList<WorksheetImageRenderedModel> worksheetImageRenderedList =
      <WorksheetImageRenderedModel>[].obs;
  RxList<WorksheetImageRenderedModel> worksheetSignatureRenderedList =
      <WorksheetImageRenderedModel>[].obs;

  Future<dynamic> jobUpdateWorkedTime(
    String visitId,
    String workedTime,
  ) async {
    try {
      dynamic check = await JobRepo().jobUpdateWorkedTime(
        visitId,
        workedTime,
      );
      if (check != null) {
        // selectedJob.value = check['data'];
        // await getJobList(token);
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in jobUpdateWorkedTime = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> getTemplates(String token) async {
    try {
      dynamic check = await JobRepo().getTemplates(token);
      if (check != null) {
        templates.value = check['data'];
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in getTemplates = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> getCheckoutJobDetail(String jobID, String token) async {
    try {
      dynamic check = await JobRepo().getCheckoutJobDetail(jobID, token);
      if (check != null) {
        checkoutJobsDetail.value = check;
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in getJobList = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> eventAddUploadSignature(
    bool fromEng,
    String path,
    String createdByEngId,
    String type,
    bool clientVisibility,
    String jobId,
    String notes,
    String token,
    String imageNameWithExt,
    String imageSize,
  ) async {
    try {
      dynamic check = await JobRepo().eventAddUploadSignature(
        path,
        createdByEngId,
        type,
        clientVisibility,
        jobId,
        notes,
        token,
        imageNameWithExt,
        imageSize,
      );
      if (check != null) {
        if (fromEng) {
          if (check['data']['url'] != null) {
            customerSignatureUrl.value = check['data']['url'];
          }
        } else {
          if (check['data']['url'] != null) {
            engSignatureUrl.value = check['data']['url'];
          }
        }
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in eventAddUploadSignature = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> updateSelectedJobStatus(
      String id,
      String newStatus,
      String currentStatus,
      String? reasonID,
      String? comment,
      String token) async {
    try {
      dynamic check = await JobRepo().updateSelectedJobStatus(
          id, newStatus, currentStatus, reasonID, comment, token);
      if (check != null) {
        selectedJob.value = check['data'];
        await getJobList(token);
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in updateSelectedJobStatus = $e");
      }
      update();
      return false;
    }
  }

  Future<dynamic> jobVisitComplete(
    String visitId,
    String jobId,
    String status,
    String workedTime,
    String proceedInvoice,
    String engSignatureUrl,
    String customerSignatureUrl,
  ) async {
    try {
      dynamic check = await JobRepo().jobVisitComplete(
        visitId,
        jobId,
        status,
        workedTime,
        proceedInvoice,
        engSignatureUrl,
        customerSignatureUrl,
      );
      if (check != null) {
        if (check['complete_job'].toString() == "1") {
          Util.dismiss();
          //Make Api call for
          Get.toNamed(routeVisitCheckout);
        } else {
          if (Get.context != null) {
            Util.dismiss();
            customDialog(
              context: Get.context!,
              barrierDismissible: false,
              titleText: AppTexts.visitSuccessful,
              middleText: AppTexts.visitCompleteSuccessfully,
              afterTextWidget: const CustomDialogTick(),
              showLeftButton: false,
              buttonLeftText: AppTexts.no,
              buttonLeftTextOnTap: () {},
              buttonRightText: AppTexts.okay,
              buttonRightTextOnTap: () {
                Get.back(closeOverlays: true);
                Get.offAllNamed(routeDashboard);
              },
            );
          }
        }
        // selectedJob.value = check['data'];
        // await getJobList(token);
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in updateSelectedJobStatus = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> jobVisitCompleteFromCheckout(
    String jobId,
    String status,
    String jobCompletedComment,
    bool proceedInvoice,
    String carePlan,
    String carePlanUserId,
  ) async {
    try {
      dynamic check = await JobRepo().jobVisitCompleteFromCheckout(
        jobId,
        status,
        jobCompletedComment,
        proceedInvoice,
        carePlan,
        carePlanUserId,
      );
      if (check != null) {
        if (check['message'] == "job visit completed successfully.") {
          Util.dismiss();
          if (check['complete_job'].toString() == "1") {
            //Make Api call for
            Get.toNamed(routeVisitCheckout);
          } else {
            if (Get.context != null) {
              customDialog(
                context: Get.context!,
                barrierDismissible: false,
                titleText: AppTexts.visitSuccessful,
                middleText: AppTexts.visitCompleteSuccessfully,
                afterTextWidget: const CustomDialogTick(),
                showLeftButton: false,
                buttonLeftText: AppTexts.no,
                buttonLeftTextOnTap: () {},
                buttonRightText: AppTexts.okay,
                buttonRightTextOnTap: () {
                  Get.back(closeOverlays: true);
                  Get.offAllNamed(routeDashboard);
                },
              );
            }
          }
        }
        // selectedJob.value = check['data'];
        // await getJobList(token);
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in updateSelectedJobStatus = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> getJobList(String token) async {
    try {
      dynamic check = await JobRepo().getJobList(token);
      if (check != null) {
        jobsList.value = check['data'];
        // jobsList.sort((a, b) => a['start_time'].compareTo(b['start_time']));
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in getJobList = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> getCompletedJobList(
      String status, String date, String token) async {
    try {
      dynamic check = await JobRepo().getCompletedJobList(status, token, date);
      if (check != null) {
        completedJobsList.value = [];
        completedJobsList.value = check['data'];
        // jobsList.sort((a, b) => a['start_time'].compareTo(b['start_time']));
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in getJobList = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> getPendingJobList(
      String status, String date, String token) async {
    // devtools.log(status);
    try {
      dynamic check = await JobRepo().getPendingJobList(status, token, date);
      if (check != null) {
        pendingJobsList.value = [];
        update();
        pendingJobsList.value = check['data'];
        // devtools.log(check['data'][0]['status']);
        // jobsList.sort((a, b) => a['start_time'].compareTo(b['start_time']));
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in getJobList = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> getOngoingJobList(String date, String token) async {
    try {
      dynamic check = await JobRepo().getOngoingJobList(token, date);

      if (check != null) {
        onGoingJobsList.value = [];

        final listOfData = check['data'] as List;
        // devtools.log(check['data'].toString());
        listOfData.forEach((element) {
          // devtools.log(element["status"].toString());
          if (element["status"] != 12 && element["status"] != 1) {
            // devtools.log("reached 1");
            onGoingJobsList.add(element);
          }
        });

        // devtools.log(onGoingJobsList.toString());

        // jobsList.sort((a, b) => a['start_time'].compareTo(b['start_time']));
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in getJobList = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> getAssignedJobList(String token) async {
    try {
      dynamic check = await JobRepo().getAssignedJobList(token);
      if (check != null) {
        assignedJobsList.value = check['data'];
        assignedJobsList
            .sort((a, b) => a['start_time'].compareTo(b['start_time']));
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in getAssignedJobList = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> uploadFormSignatureWithApi(String token) async {
    try {
      if (worksheetSignatureRenderedList.isNotEmpty) {
        for (int i = 0; i < worksheetSignatureRenderedList.length; i++) {
          if (worksheetSignatureRenderedList[i].filePath.isNotEmpty) {
            dynamic check = await JobRepo().uploadFormImagesWithApi(
              token,
              worksheetSignatureRenderedList[i].filePath,
            );
            if (check != null) {
              worksheetSignatureRenderedList[i].uploadUrl = check['url'];
            }
          }
        }
        update();
        return true;
      } else {
        update();
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in uploadFormImagesWithApi = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> uploadFormImagesWithApi(String token) async {
    try {
      if (worksheetImageRenderedList.isNotEmpty) {
        for (int i = 0; i < worksheetImageRenderedList.length; i++) {
          if (worksheetImageRenderedList[i].filePath.isNotEmpty) {
            dynamic check = await JobRepo().uploadFormImagesWithApi(
              token,
              worksheetImageRenderedList[i].filePath,
            );
            if (check != null) {
              worksheetImageRenderedList[i].uploadUrl = check['url'];
            }
          }
        }
        update();
        return true;
      } else {
        update();
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in uploadFormImagesWithApi = $e");
      }
      update();
      return false;
    }
  }

  Future<bool> submitWorkSheetWithApi(String identifier, String token,
      int jobId, List<WorksheetDataSubmitModel> list) async {
    try {
      dynamic check = await JobRepo().submitWorkSheetWithApi(
          identifier,
          token,
          jobId,
          list,
          worksheetImageRenderedList,
          worksheetSignatureRenderedList);
      if (check != null) {
        update();
        return true;
      }
      update();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Exception in submitWorkSheetWithApi = $e");
      }
      update();
      return false;
    }
  }

  updateSelectedWorksheet(Map<dynamic, dynamic> newWorksheet) {
    selectedWorksheet.value = newWorksheet;
    update();
  }

  addWorksheetDataSubmitModelList(
      WorksheetDataSubmitModel worksheetDataSubmitModel) {
    worksheetDataSubmitModelList.add(worksheetDataSubmitModel);
    update();
  }

  clearWorksheetDataSubmitModelList() {
    worksheetDataSubmitModelList.clear();
    update();
  }

  addWorksheetImageRenderedList(
      WorksheetImageRenderedModel worksheetImageRenderedModel) {
    var temp = worksheetImageRenderedList.firstWhereOrNull(
        (p0) => p0.imageKey == worksheetImageRenderedModel.imageKey);
    if (temp == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        worksheetImageRenderedList.add(worksheetImageRenderedModel);
        update();
      });
    }
  }

  updateWorksheetImageRenderedList(
      WorksheetImageRenderedModel worksheetImageRenderedModel) {
    int index = worksheetImageRenderedList.indexWhere(
        (element) => element.imageKey == worksheetImageRenderedModel.imageKey);
    if (index != -1) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        worksheetImageRenderedList.removeAt(index);
        worksheetImageRenderedList.insert(index, worksheetImageRenderedModel);
        update();
      });
    }
  }

  clearWorksheetImageRenderedList() {
    worksheetImageRenderedList.clear();
    update();
  }

  addWorksheetSignatureRenderedList(
      WorksheetImageRenderedModel worksheetSignatureRenderedModel) {
    var temp = worksheetSignatureRenderedList.firstWhereOrNull(
        (p0) => p0.imageKey == worksheetSignatureRenderedModel.imageKey);
    if (temp == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        worksheetSignatureRenderedList.add(worksheetSignatureRenderedModel);
        update();
      });
    }
  }

  updateWorksheetSignatureRenderedList(
      WorksheetImageRenderedModel worksheetSignatureRenderedModel) {
    int index = worksheetSignatureRenderedList.indexWhere((element) =>
        element.imageKey == worksheetSignatureRenderedModel.imageKey);
    if (index != -1) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        log("Updating value Signature of ${worksheetSignatureRenderedModel.imageTitle} new value = ${worksheetSignatureRenderedModel.isFilled}, isRequired = ${worksheetSignatureRenderedModel.isRequired}");
        worksheetSignatureRenderedList.removeAt(index);
        worksheetSignatureRenderedList.insert(
            index, worksheetSignatureRenderedModel);
        update();
      });
    }
  }

  clearWorksheetSignatureRenderedList() {
    worksheetSignatureRenderedList.clear();
    update();
  }

  resetWorksheetControllerData() {
    worksheetDataSubmitModelList.clear();
    worksheetImageRenderedList.clear();
    worksheetSignatureRenderedList.clear();
    update();
  }

  deleteAllSignatureFromDevice() {
    worksheetSignatureRenderedList.map((element) async {
      await File(element.filePath).delete();
      element.filePath = "";
      log("After Delete Path = ${element.filePath}");
    });
  }

  changeSelectedJob(Map<String, dynamic> newJob) {
    selectedJob.value = newJob;
    update();
  }

  changeIsLoading(bool value) {
    isLoading.value = value;
    update();
  }

  resetJob() {
    selectedJob.value = <String, dynamic>{};
    customerSignatureUrl.value = "";
    engSignatureUrl.value = "";
    checkoutJobsDetail.value = <String, dynamic>{};
    update();
  }
}
