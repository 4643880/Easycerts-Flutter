import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_certs/constants.dart';
import 'package:easy_certs/controller/auth_controller.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/controller/notes_controller.dart';
import 'package:easy_certs/helper/api.dart';
import 'package:easy_certs/repository/auth_repo.dart';
import 'package:easy_certs/screens/components/custom_empty_widget.dart';
import 'package:easy_certs/screens/components/large_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;
import '../../config/routes.dart';
import '../../helper/app_colors.dart';
import '../../theme/text_styles.dart';
import '../image_view/image_view.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:path/path.dart' as path;

class Notes extends StatefulWidget {
  Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();

  @override
  Widget build(BuildContext context) {
    // devtools.log(Get.find<JobController>().selectedJob['Notes'].toString());
    return Scaffold(
      body: HawkFabMenu(
        backgroundColor: Colors.black87,
        blur: 0.0,
        openIcon: Icons.add,
        closeIcon: Icons.close,
        icon: AnimatedIcons.menu_close,
        fabColor: AppColors.primary,
        iconColor: Colors.white,
        hawkFabMenuController: hawkFabMenuController,
        items: [
          // HawkFabMenuItem(
          //   label: 'Diagram',
          //   ontap: () {
          //     devtools.log(
          //         "After => ${Get.find<JobController>().selectedJob['Notes'].toString()}");
          //   },
          //   icon: const Icon(
          //     Icons.edit_document,
          //     color: Colors.white,
          //   ),
          //   color: Colors.black,
          //   labelColor: Colors.white,
          //   labelBackgroundColor: Colors.transparent,
          // ),
          HawkFabMenuItem(
            label: 'Signature',
            ontap: () {
              Get.toNamed(routeTypeSignature);
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            color: Colors.black,
            labelColor: Colors.white,
            labelBackgroundColor: Colors.transparent,
          ),
          HawkFabMenuItem(
            label: 'Notes',
            ontap: () {
              Get.toNamed(routeTypeNote);
            },
            icon: const Icon(
              Icons.note_add_sharp,
              color: Colors.white,
            ),
            color: Colors.black,
            labelColor: Colors.white,
            labelBackgroundColor: Colors.transparent,
          ),
          HawkFabMenuItem(
            label: 'Photos',
            ontap: () async {
              File? fileOfImage =
                  await Get.find<NotesController>().pickImageFromGallery();

              if (fileOfImage != null) {
                Get.toNamed(routeDisplayImageOfNote, arguments: fileOfImage);
              }
            },
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
            color: Colors.black,
            labelColor: Colors.white,
            labelBackgroundColor: Colors.transparent,
          ),
        ],
        body: GetBuilder<JobController>(
          builder: (jobController) {
            // devtools.log(
            //     "Before => ${Get.find<JobController>().selectedJob['Notes'].toString()}");
            return (jobController.listOfSelectedJobNotes.isNotEmpty &&
                    jobController.listOfSelectedJobNotes.length > 0
                ?
                // jobController.selectedJob['Notes'] != null &&
                //       jobController.selectedJob['Notes'].length > 0)
                //   ?
                Obx(
                    () => ListView.builder(
                        padding: EdgeInsets.only(bottom: 80.h),
                        itemCount: jobController.listOfSelectedJobNotes.length,
                        // itemCount: jobController.selectedJob['Notes'].length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                top: 8.h,
                                bottom: 8.h,
                                right: 16.w,
                                left: 160.w),
                            padding: EdgeInsets.only(
                              top: 16.h,
                              bottom: 16.h,
                              right: 10.w,
                              left: 10.w,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius4),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.grey.withOpacity(0.4),
                                  offset: const Offset(0, 2),
                                  blurRadius: kBorderRadius4,
                                  spreadRadius: kBorderRadius4,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  jobController.listOfSelectedJobNotes[index]
                                              ['ref_number'] !=
                                          null
                                      ? "You(${jobController.listOfSelectedJobNotes[index]['ref_number'] ?? " "})"
                                      : "",
                                  textAlign: TextAlign.right,
                                  style: kTextStyle12Normal,
                                ),
                                if (jobController.listOfSelectedJobNotes[index]
                                            ['url'] !=
                                        null &&
                                    jobController.listOfSelectedJobNotes[index]
                                            ['url']
                                        .toString()
                                        .isNotEmpty)
                                  CustomNotesDisplay(
                                    url: jobController
                                        .listOfSelectedJobNotes[index]['url'],
                                    type: jobController
                                        .listOfSelectedJobNotes[index]['type'],
                                    name: jobController
                                                .listOfSelectedJobNotes[index]
                                            ['notes'] ??
                                        "",
                                  ),
                                Text(
                                  jobController.listOfSelectedJobNotes[index]
                                          ['notes'] ??
                                      "",
                                  textAlign: TextAlign.right,
                                  style: kTextStyle8Normal.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                : CustomEmptyWidget(text: "No Notes Available"));
          },
        ),
      ),
    );
  }
}

class CustomNotesDisplay extends StatelessWidget {
  CustomNotesDisplay({
    Key? key,
    required this.url,
    required this.name,
    required this.type,
  }) : super(key: key);
  String url, type, name;

  @override
  Widget build(BuildContext context) {
    return (type == 'pdf')
        ? Padding(
            padding: EdgeInsets.only(
              top: 16.h,
              bottom: 16.h,
            ),
            child: CustomLargeButton(
              height: 40.h,
              width: 100.w,
              title: "SHOW FILE",
              borderColor: AppColors.primary,
              bgColor: AppColors.white,
              textColor: AppColors.primary,
              onPressed: () async {
                Get.toNamed(routePdfView, arguments: url);
                // String path = await downloadFile(url);
              },
            ),
          )
        : InkWell(
            onTap: () {
              Get.toNamed(routeImageView, arguments: ImageViewModel(url, name));
            },
            child: CachedNetworkImage(
              height: 180.h,
              imageUrl: url,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
  }
}
