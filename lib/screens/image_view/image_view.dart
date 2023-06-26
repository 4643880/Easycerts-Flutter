import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/helper/app_texts.dart';
import 'package:easy_certs/screens/components/custom_app_bar.dart';
import 'package:easy_certs/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewModel {
  String url, name;

  ImageViewModel(this.url, this.name);
}

class ImageView extends StatelessWidget {
  ImageView({Key? key, required this.imageViewModel}) : super(key: key);
  ImageViewModel imageViewModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: AppTexts.easyCerts,
        displayLeading: true,
        centerTitle: false,
        backgroundColor: AppColors.black,
      ),
      body: Stack(
        children: [
          PhotoView(
            imageProvider: CachedNetworkImageProvider(imageViewModel.url),
          ),
          // Positioned(
          //   bottom: 16.h,
          //   left: 16.w,
          //   child: Container(
          //     height: 30.h,
          //     color: AppColors.black,
          //     alignment: Alignment.centerLeft,
          //     padding: EdgeInsets.symmetric(horizontal: 10.w),
          //     child: Text(
          //       imageViewModel.name,
          //       style: kTextStyle12Normal.copyWith(
          //         color: AppColors.white,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
