import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:developer' as devtools show log;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_certs/controller/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

import '../constants.dart';
import '../utils/util.dart';

class ApiHelper {
  // static String baseUrl = kLiveBaseUrl;
  static String baseUrl = kDevBaseUrl;

  static Map<String, String> defaultHeader = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  static Map<String, String> getAuthHeader() {
    AuthController authController = Get.find();
    String token = authController.token.value;
    return <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
  }

  static Map<String, Uri> getApiUrls() {
    return <String, Uri>{
      kLogin: Uri.parse("${baseUrl}api/login"),
      kJob: Uri.parse("${baseUrl}api/job"),
      kSubmitForm: Uri.parse("${baseUrl}api/worksheet"),
      kUploadFile: Uri.parse("${baseUrl}api/upload_files"),
      kGetNotifications: Uri.parse("${baseUrl}api/pushNotification/list"),
      kMarkNotificationAsRead: Uri.parse("${baseUrl}api/pushNotification"),
      kJobList: Uri.parse("${baseUrl}api/job/list"),
      kJobAssigned: Uri.parse("${baseUrl}api/job/assigned"),
      kUpdateEngLocation: Uri.parse("${baseUrl}api/engineer/update/location"),
      kJobUpdateStatus: Uri.parse("${baseUrl}api/job/update/status"),
      kEventAdd: Uri.parse("${baseUrl}api/event/add"),
      kJobAttachments: Uri.parse("${baseUrl}job_attachments/"),
      kJobVisitComplete: Uri.parse("${baseUrl}api/job-visits/complete"),
      kJobComplete: Uri.parse("${baseUrl}api/job/complete"),
      kTemplates: Uri.parse("${baseUrl}api/templates"),
      kJobUpdateWorkedTime: Uri.parse("${baseUrl}api/job/update/worked_time"),
    };
  }

  static String kLogin = "login";
  static String kJob = "job";
  static String kSubmitForm = "kSubmitForm";
  static String kUploadFile = "kUploadFile";
  static String kGetNotifications = "kGetNotifications";
  static String kMarkNotificationAsRead = "kMarkNotificationAsRead";
  static String kJobList = "kJobList";
  static String kJobAssigned = "kJobAssigned";
  static String kUpdateEngLocation = "kUpdateEngLocation";
  static String kJobUpdateStatus = "kJobUpdateStatus";
  static String kEventAdd = "kEventAdd";
  static String kJobAttachments = "kJobAttachments";
  static String kJobVisitComplete = "kJobVisitComplete";
  static String kJobComplete = "kJobComplete";
  static String kTemplates = "kTemplates";
  static String kJobUpdateWorkedTime = "kJobUpdateWorkedTime";

  Future<dynamic> get(
      String apiName, Uri uri, Map<String, String>? header) async {
    if (kDebugMode) {
      print("Header = $header");
    }
    bool internetAvailable = await internetAvailabilityCheck();
    if (internetAvailable) {
      http.Response response = await http.get(
        uri,
        headers: header ?? ApiHelper.defaultHeader,
      );
      if (kDebugMode) {
        print("API => Get => Link => ${uri.toString()}");
      }
      bool responseGood = await responseIsGoodCheck(apiName, response);
      if (responseGood) {
        // devtools.log(jsonDecode(response.body)["data"]['status']);
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<dynamic> put(String apiName, Uri uri, Map<String, String>? header,
      Map<String, dynamic>? body) async {
    bool internetAvailable = await internetAvailabilityCheck();
    if (internetAvailable) {
      http.Response response = await http.put(uri,
          headers: header ?? ApiHelper.defaultHeader, body: body);
      if (kDebugMode) {
        print("API => Put => Link => ${uri.toString()}");
      }
      bool responseGood = await responseIsGoodCheck(apiName, response);
      if (responseGood) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<dynamic> delete(
      String apiName, Uri uri, Map<String, String>? header) async {
    bool internetAvailable = await internetAvailabilityCheck();
    if (internetAvailable) {
      http.Response response = await http.delete(
        uri,
        headers: header ?? ApiHelper.defaultHeader,
      );
      if (kDebugMode) {
        print("API => Delete => Link => ${uri.toString()}");
      }
      bool responseGood = await responseIsGoodCheck(apiName, response);
      if (responseGood) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<dynamic> post(String apiName, Uri uri, Map<String, String>? header,
      Map<String, dynamic> body) async {
    log("Body = $body");
    log("Header = $header");
    bool internetAvailable = await internetAvailabilityCheck();
    if (internetAvailable) {
      http.Response responseData = await http.post(
        uri,
        headers: header ?? ApiHelper.defaultHeader,
        body: jsonEncode(body),
      );
      if (kDebugMode) {
        print("API => Post => Link => ${uri.toString()}");
      }
      bool responseGood = await responseIsGoodCheck(apiName, responseData);
      if (responseGood) {
        return jsonDecode(responseData.body);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<dynamic> signatureUpload(
    Uri uri,
    Map<String, String>? header,
    File imageFile,
    String createdByEngId,
    String type,
    bool clientVisibility,
    String jobId,
    String notes,
    String token,
    String imageNameWithExt,
    String imageSize,
  ) async {
    bool internetAvailable = await internetAvailabilityCheck();
    if (internetAvailable) {
      String temp = p.extension(imageFile.path).replaceAll(".", "");

      http.MultipartRequest request = http.MultipartRequest("POST", uri);
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: imageNameWithExt,
        contentType: MediaType(
          'image',
          temp,
        ),
      );
      request.fields['created_by'] = createdByEngId.toString();
      // request.fields['url'] = url;
      request.fields['token'] = token;
      request.fields['type'] = type;
      request.fields['clientVisibility'] = clientVisibility ? "1" : "0";
      request.fields['job_id'] = jobId;
      request.fields['notes'] = notes;
      request.fields['attachment_type'] = "image";

      // request.fields['image'] = createdByEngId.toString();

      print("fields = ${request.fields}");
      request.files.add(multipartFile);
      request.headers.addAll(header!);
      http.StreamedResponse streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print("API => Post => Link => ${uri.toString()}");
      }
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<dynamic> imageUpload(Uri uri, Map<String, String>? header,
      File imageFile, Map<String, dynamic>? fields) async {
    bool internetAvailable = await internetAvailabilityCheck();
    if (internetAvailable) {
      String temp = p.extension(imageFile.path).replaceAll(".", "");

      http.MultipartRequest request = http.MultipartRequest("POST", uri);
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'picture',
        imageFile.path,
        contentType: MediaType(
          'image',
          temp,
        ),
      );
      if (fields != null) {
        fields.map((key, value) {
          return request.fields[key] = value;
        });
      }
      request.files.add(multipartFile);
      request.headers.addAll(header!);
      http.StreamedResponse streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print("API => Post => Link => ${uri.toString()}");
      }
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<bool> responseIsGoodCheck(
      String apiName, http.Response response) async {
    if (response.statusCode == 404) {
      if (kDebugMode) {
        print("********* Response 404 *********");
        print("$apiName\n${response.body}");
      }
      return false;
    } else if (response.statusCode == 422) {
      if (kDebugMode) {
        print("********* Response 422 *********");
        print("$apiName\n${response.body}.");
      }
      return true;
    } else if (response.statusCode == 400) {
      if (kDebugMode) {
        print("********* Response 400 *********");
        print("$apiName\n${response.body}.");
      }
      Util.showErrorSnackBar(jsonDecode(response.body)['message']);
      return false;
    } else if (response.statusCode == 401) {
      if (kDebugMode) {
        print("********* Response 401 *********");
        print("$apiName\n${response.body}.");
      }
      return false;
    } else if (response.statusCode == 200) {
      if (kDebugMode) {
        print("********* Response Is Good *********");
        print("$apiName\n${response.body}.");
      }
      return true;
    } else if (response.statusCode == 202) {
      if (kDebugMode) {
        print("********* Response Is Good *********");
        print("$apiName\n${response.body}.");
      }
      return true;
    } else {
      if (kDebugMode) {
        print(
            "********* Response ${response.statusCode} UnConfigure *********");
        print("$apiName\n${response.body}");
      }
      return false;
    }
  }

  Future<bool> internetAvailabilityCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      Util.showErrorSnackBar("Internet Not Available");
      return false;
    }
  }
}
