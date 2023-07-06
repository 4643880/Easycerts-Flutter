import 'dart:io';
import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/controller/notes_controller.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DisplayNotesImageScreen extends StatelessWidget {
  final args = Get.arguments;
  TextEditingController _controller = TextEditingController();
  DisplayNotesImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    devtools.log(args.toString());
    return Theme(
      data: ThemeData(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.black87,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Add Captions"),
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 600.h,
                  width: 1.sw,
                  child: Image.file(
                    File(
                      args.path,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.black38.withOpacity(0.1),
          ),
          child: Row(
            children: [
              Container(
                height: 30.w,
                width: 30.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                  controller: _controller,
                  decoration: InputDecoration(
                    // label: const Text("Add a caption..."),
                    border: InputBorder.none,
                    hintText: "Add a caption...",
                    hintStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Util.showLoading("Uploading Note...");
                  final response =
                      await Get.find<NotesController>().uploadNotesImage(
                    jobId:
                        Get.find<JobController>().selectedJob["id"].toString(),
                    notes: _controller.text.trim(),
                    token: Get.find<AuthController>().token.value,
                  );
                  if (response != null && response["data"] != null) {
                    // devtools.log("Alpha => " + response.toString());
                    // Adding Data into State Management List
                    // devtools.log(
                    //     "Before => ${Get.find<JobController>().selectedJob['Notes'].toString()}");
                    Get.find<JobController>().listOfSelectedJobNotes.insert(
                      0,
                      {
                        "jobId": Get.find<JobController>()
                            .selectedJob["id"]
                            .toString(),
                        "notes": _controller.text.trim(),
                        "url": response["data"]["url"],
                        "type": "image",
                      },
                    );
                    Get.find<JobController>().update();
                    // devtools.log(
                    //     "After => ${Get.find<JobController>().selectedJob['Notes'].toString()}");
                  } else {
                    // devtools.log("reached here");
                  }
                  Util.dismiss();
                },
                child: Container(
                  height: 55.w,
                  width: 55.w,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 45.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
