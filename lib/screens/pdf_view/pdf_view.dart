import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/screens/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../helper/app_texts.dart';

class PdfView extends StatelessWidget {
  PdfView({Key? key, required this.url}) : super(key: key);
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: AppTexts.easyCerts,
        displayLeading: true,
        centerTitle: false,
        backgroundColor: AppColors.primary,
      ),
      body: SfPdfViewer.network(
        headers: const {"content-disposition": "inline"},
        url,
      ),
    );
  }
}
