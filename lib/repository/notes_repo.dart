import 'dart:developer';
import 'dart:io';

import 'package:easy_certs/controller/notes_controller.dart';
import 'package:easy_certs/helper/api.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NotesRepo {
  Future<dynamic> uploadImageOfNotes({
    required String jobId,
    required String notes,
    required String token,
    required int type,
  }) async {
    Uri uri = Uri.parse(
      "${ApiHelper.getApiUrls()[ApiHelper.kUploadNotesImage]!}?attachment_type=image&client_visibility=1&job_id=$jobId&notes=$notes&token=$token&type=$type",
    );

    dynamic dynamicData = ApiHelper().imageUpload(
      uri,
      ApiHelper.defaultHeader,
      Get.find<NotesController>().pickedImageAsFile!,
      {},
    );

    log("uploaded");
    return dynamicData;
  }

  Future<dynamic> uploadSignatureOfNotes({
    required String jobId,
    required String token,
    required File imageFile,
    required int type,
  }) async {
    Uri uri = Uri.parse(
      "${ApiHelper.getApiUrls()[ApiHelper.kUploadNotesSignature]!}?attachment_type=image&client_visibility=1&job_id=$jobId&token=$token&type=$type",
    );

    dynamic dynamicData = ApiHelper().imageUpload(
      uri,
      ApiHelper.defaultHeader,
      imageFile,
      {},
    );

    log("uploaded");
    return dynamicData;
  }

  // Upload Text Note
  Future<dynamic> uploadTextNote({
    required String note,
    required String token,
    required String jobId,
    required int type,
  }) {
    Uri uri = Uri.parse(
        "${ApiHelper.getApiUrls()[ApiHelper.kUploadNotesText]}?attachment_type=note&client_visibility=1&job_id=$jobId&notes=$note&token=$token&type=$type");

    dynamic dynamicData =
        ApiHelper().post("Upload Text Note", uri, ApiHelper.defaultHeader, {});
    return dynamicData;
  }
}
