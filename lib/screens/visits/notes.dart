import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_certs/constants.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/screens/components/custom_empty_widget.dart';
import 'package:easy_certs/screens/components/large_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import '../../helper/app_colors.dart';
import '../../theme/text_styles.dart';
import '../image_view/image_view.dart';

class Notes extends StatelessWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
      return (jobController.selectedJob['Notes'] != null &&
              jobController.selectedJob['Notes'].length > 0)
          ? ListView.builder(
              padding: EdgeInsets.only(bottom: 80.h),
              itemCount: jobController.selectedJob['Notes'].length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                      top: 8.h, bottom: 8.h, right: 16.w, left: 160.w),
                  padding: EdgeInsets.only(
                    top: 16.h,
                    bottom: 16.h,
                    right: 10.w,
                    left: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(kBorderRadius4),
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
                        "You(${jobController.selectedJob['Notes'][index]['ref_number'] ?? " "})",
                        textAlign: TextAlign.right,
                        style: kTextStyle12Normal,
                      ),
                      if (jobController.selectedJob['Notes'][index]['url'] !=
                              null &&
                          jobController.selectedJob['Notes'][index]['url']
                              .toString()
                              .isNotEmpty)
                        CustomNotesDisplay(
                          url: jobController.selectedJob['Notes'][index]['url'],
                          type: jobController.selectedJob['Notes'][index]
                              ['type'],
                          name: jobController.selectedJob['Notes'][index]
                                  ['notes'] ??
                              "",
                        ),
                      Text(
                        jobController.selectedJob['Notes'][index]['notes'] ??
                            "",
                        textAlign: TextAlign.right,
                        style: kTextStyle8Normal.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      // SizedBox(
                      //   height: 6.h,
                      // ),
                      // Align(
                      //   alignment: Alignment.bottomLeft,
                      //   child: Text(
                      //     jobController.selectedJob['Notes'][index]['notes'] ??
                      //         "",
                      //     textAlign: TextAlign.left,
                      //     style: kTextStyle8Normal,
                      //   ),
                      // ),
                    ],
                  ),
                );
              })
          : CustomEmptyWidget(text: "No Notes Available");
    });
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
