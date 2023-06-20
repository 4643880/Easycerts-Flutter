import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:developer' as devtools show log;
import 'package:easy_certs/helper/job_status.dart';

import '../helper/api.dart';
import '../model/worksheet_data_submit_model.dart';
import '../model/worksheet_image_rendered_model.dart';
import '../utils/extra_function.dart';

class JobRepo {
  Future<dynamic> jobUpdateWorkedTime(
    String visitId,
    String workedTime,
  ) async {
    dynamic dynamicData = await ApiHelper().post(
        "job Update Work Time Api",
        ApiHelper.getApiUrls()[ApiHelper.kJobUpdateWorkedTime]!,
        ApiHelper.getAuthHeader(), <String, String>{
      "id": visitId,
      "duration": workedTime,
    });
    return dynamicData;
  }

  Future<dynamic> getTemplates(String token) async {
    Uri api = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kTemplates]!}?token=$token");
    dynamic dynamicData =
        await ApiHelper().get("get Templates", api, ApiHelper.getAuthHeader());
    return dynamicData;
  }

  Future<dynamic> getCheckoutJobDetail(String jobID, String token) async {
    Uri api = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kJob]!}/$jobID/order_detail");
    dynamic dynamicData = await ApiHelper()
        .get("get Checkout Job Detail", api, ApiHelper.getAuthHeader());
    return dynamicData;
  }

  Future<dynamic> eventAddUploadSignature(
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
    dynamic dynamicData = await ApiHelper().signatureUpload(
      ApiHelper.getApiUrls()[ApiHelper.kEventAdd]!,
      <String, String>{
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      File(path),
      createdByEngId,
      type,
      clientVisibility,
      jobId,
      notes,
      token,
      imageNameWithExt,
      imageSize,
    );
    return dynamicData;
  }

  Future<dynamic> jobVisitCompleteFromCheckout(
    String jobId,
    String status,
    String jobCompletedComment,
    bool proceedInvoice,
    String carePlan,
    String carePlanUserId,
  ) async {
    dynamic dynamicData = await ApiHelper().post(
      "job Visit Complete From Checkout Api",
      ApiHelper.getApiUrls()[ApiHelper.kJobComplete]!,
      ApiHelper.getAuthHeader(),
      <String, String>{
        "job_id": jobId,
        "status": status,
        "job_completed_comment": jobCompletedComment,
        "proceed_invoice": proceedInvoice ? "1" : "0",
        "care_plan": carePlan,
        "care_plan_user_id": carePlanUserId,
      },
    );
    return dynamicData;
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
    dynamic dynamicData = await ApiHelper().post(
        "job Visit Complete Api",
        ApiHelper.getApiUrls()[ApiHelper.kJobVisitComplete]!,
        ApiHelper.getAuthHeader(), <String, String>{
      "_visit_id": visitId,
      "_job_id": jobId,
      "visit_id": visitId,
      "status": status,
      "worked_time": workedTime,
      "proceed_invoice": proceedInvoice,
      "engineer_signature": engSignatureUrl,
      "customer_signature": customerSignatureUrl,
    });
    return dynamicData;
  }

  Future<dynamic> updateSelectedJobStatus(
    String id,
    String newStatus,
    String currentStatus,
    String? reasonID,
    String? comment,
    String token,
  ) async {
    String jobLogs =
        "Current visit status is $currentStatus.New visit status is $newStatus.${JobStatus.returnJobStatusUpdateMessage(int.parse(newStatus))} Calling update status api from device ${await getDeviceModel()}.";
    Uri api = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kJobUpdateStatus]!}?token=$token");
    dynamic dynamicData = await ApiHelper().post(
      "update Selected Job Status",
      api,
      <String, String>{
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      (reasonID != null && comment != null)
          ? <String, String>{
              "id": id,
              "status": newStatus,
              "current_status": currentStatus,
              "reason_id": reasonID,
              "comment": comment,
              "job_logs": jobLogs,
              "duration": "1000",
              "token": token
            }
          : <String, String>{
              "id": id,
              "status": newStatus,
              "current_status": currentStatus,
              "job_logs": jobLogs,
              "duration": "1000",
              "token": token
            },
    );
    return dynamicData;
  }

  Future<dynamic> getJobList(String token) async {
    Uri api = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kJobList]!}?token=$token");
    dynamic dynamicData =
        await ApiHelper().get("get Job List", api, <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    return dynamicData;
  }

  Future<dynamic> getCompletedJobList(
      String status, String token, String date) async {
    Uri api = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kJobList]!}?date=$date&status=$status&token=$token");
    // devtools.log(api.toString());
    dynamic dynamicData =
        await ApiHelper().get("get Completed Job List", api, <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    return dynamicData;
  }

  Future<dynamic> getPendingJobList(
      String status, String token, String date) async {
    devtools.log(status);
    Uri api = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kJobList]!}?date=$date&status=$status&token=$token");
    // devtools.log(api.toString());
    dynamic dynamicData =
        await ApiHelper().get("get Pending Job List", api, <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    return dynamicData;
  }

  Future<dynamic> getOngoingJobList(String token, String date) async {
    Uri api = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kJobList]!}?date=$date&token=$token");
    // devtools.log(api.toString());
    dynamic dynamicData =
        await ApiHelper().get("get Ongoing Job List", api, <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    return dynamicData;
  }

  Future<dynamic> getAssignedJobList(String token) async {
    Uri api = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kJobAssigned]!}?token=$token");

    dynamic dynamicData =
        await ApiHelper().get("get Assigned Job List", api, <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    return dynamicData;
  }

  Future<dynamic> uploadFormImagesWithApi(String token, String path) async {
    //TODO change JobID
    dynamic dynamicData = await ApiHelper().imageUpload(
      ApiHelper.getApiUrls()[ApiHelper.kUploadFile]!,
      ApiHelper.getAuthHeader(),
      File(path),
      null,
    );
    return dynamicData;
  }

  Future<dynamic> submitWorkSheetWithApi(
      String identifier,
      String token,
      int jobId,
      List<WorksheetDataSubmitModel> list,
      List<WorksheetImageRenderedModel> imageList,
      List<WorksheetImageRenderedModel> signatureList) async {
    Uri api = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kSubmitForm]!}/$identifier");
    List<Map<String, String>> check = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].f_value.isNotEmpty) {
        check.add({
          "f_name": list[i].f_name,
          "f_type": list[i].f_type,
          "f_value": list[i].f_value,
        });
      }
    }
    for (int i = 0; i < imageList.length; i++) {
      if (imageList[i].uploadUrl.isNotEmpty) {
        check.add({
          "f_name": imageList[i].imageKey,
          "f_type": "image",
          "f_value": imageList[i].uploadUrl,
        });
      }
    }
    for (int i = 0; i < signatureList.length; i++) {
      if (signatureList[i].uploadUrl.isNotEmpty) {
        check.add({
          "f_name": signatureList[i].imageKey,
          "f_type": "signature",
          "f_value": signatureList[i].uploadUrl,
        });
      }
    }
    String finalJson = check.map((e) => jsonEncode(e)).toList().toString();
    log("api = $api");
    dynamic dynamicData = await ApiHelper().post(
      "Submit WorkSheets",
      api,
      ApiHelper.getAuthHeader(),
      <String, dynamic>{
        "job_id": jobId,
        "worksheet_data": finalJson,
        // "worksheet_data": jsonEncode(
        //         '[{"f_name": "select_1","f_type": "select","f_value": "list[i].f_value"},{"f_name": "select_2","f_type": "select","f_value": "list[i].f_value"},{"f_name": "text_1","f_type": "text","f_value": "list[i].f_value"},{"f_name": "text_2","f_type": "text","f_value": "list[i].f_value"},{"f_name": "date_1","f_type": "date","f_value": "list[i].f_value"},{"f_name": "text_3","f_type": "text","f_value": "list[i].f_value"},{"f_name": "text_4","f_type": "text","f_value": "list[i].f_value"},{"f_name": "date_2","f_type": "date","f_value": "list[i].f_value"},{"f_name": "text_5","f_type": "text","f_value": "list[i].f_value"},{"f_name": "text_6","f_type": "text","f_value": "list[i].f_value"},{"f_name": "date_3","f_type": "date","f_value": "list[i].f_value"},{"f_name": "text_7","f_type": "text","f_value": "list[i].f_value"},{"f_name": "text_8","f_type": "text","f_value": "list[i].f_value"},{"f_name": "date_4","f_type": "date","f_value": "list[i].f_value"},{"f_name": "text_9","f_type": "text","f_value": "list[i].f_value"},{"f_name": "text_10","f_type": "text","f_value": "list[i].f_value"},{"f_name": "date_5","f_type": "date","f_value": "list[i].f_value"},{"f_name": "image_1","f_type": "image","f_value": "https://easycerts.greelogix.com/components/admin/forms/submissions/4/12-10-2022/1665587954.ad328c22-ee98-4f8c-bb36-9a4da397d3c11222276860926421448.jpg"}]')
        //     .toString()
        //     .replaceAll("\\", ""),
      },
    );
    return dynamicData;
  }
}
