import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/controller/notes_controller.dart';
import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/screens/components/large_button.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:developer' as devtools show log;

class TypeNoteScreen extends StatelessWidget {
  RxInt noteLength = 0.obs;
  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TypeNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Add Note"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => Text(
                      "${noteLength.value} / 2000",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Form(
                key: _key,
                child: TextFormField(
                  controller: controller,
                  minLines: 5,
                  maxLines: 35,
                  maxLength: 2000,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Note can not be empty.";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    noteLength.value = value.length;
                    devtools.log(noteLength.toString());
                  },
                  decoration: const InputDecoration(
                    counterText: "",
                    alignLabelWithHint: true,
                    label: Text("Note"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(32.0),
        child: CustomLargeButton(
          onPressed: () async {
            if (_key.currentState!.validate()) {
              final response = await Get.find<NotesController>().uploadTextNote(
                jobId: Get.find<JobController>().selectedJob["id"].toString(),
                note: controller.text,
                token: Get.find<AuthController>().token.value,
                type: 7,
              );
              devtools.log("Form Submitted");
              if (response != null && response["data"] != null) {
                Get.find<JobController>().listOfSelectedJobNotes.insert(
                  0,
                  {
                    "notes": controller.text,
                    "type": "note",
                  },
                );
              }
            } else {
              devtools.log("Form Faild");
            }
          },
          title: "Submit",
          bgColor: AppColors.success,
          textColor: AppColors.white,
        ),
      ),
    );
  }
}
