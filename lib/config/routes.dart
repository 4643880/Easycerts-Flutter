import 'package:easy_certs/screens/authentication/login_screen.dart';
import 'package:easy_certs/screens/dashboard/dashboard.dart';
import 'package:easy_certs/screens/image_view/image_view.dart';
import 'package:easy_certs/screens/pdf_view/pdf_view.dart';
import 'package:easy_certs/screens/reject_job/reject_job.dart';
import 'package:easy_certs/screens/splash/splash_screen.dart';
import 'package:easy_certs/screens/visits/visit_detail.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/both_signature/both_signature.dart';
import '../screens/no_access/no_access.dart';
import '../screens/visit_checkout/checkout.dart';
import '../screens/visits/worksheets_detail/worksheets_detail_screen.dart';
import '../utils/keyboard_dismiss.dart';

const routeSplash = '/routeSplash';
const routeLogin = '/routeLogin';
const routeDashboard = '/routeDashboard';
const routeWorksheetsDetail = '/routeWorksheetsDetail';
const routeVisitDetail = '/routeVisitDetail';
const routeImageView = '/routeImageView';
const routePdfView = '/routePdfView';
const routeBothSignature = '/routeBothSignature';
const routeVisitCheckout = '/routeVisitCheckout';
const routeRejectJob = '/routeRejectJob';
const routeNoAccess = '/routeNoAccess';

class Routes {
  static final routes = [
    GetPage(name: routeSplash, page: () => const TKDismiss(SplashScreen())),
    GetPage(name: routeLogin, page: () => TKDismiss(LoginScreen())),
    GetPage(
      name: routeDashboard,
      page: () => const TKDismiss(Dashboard()),
    ),
    GetPage(
        name: routeWorksheetsDetail,
        page: () => const TKDismiss(WorksheetsDetailScreen()),
        binding: BindingsBuilder(() {
          Util.showLoading("Please Wait From Binding...");
        })),
    GetPage(
      name: routeVisitDetail,
      transition: Transition.noTransition,
      transitionDuration: const Duration(seconds: 0),
      page: () => TKDismiss(VisitDetail()),
    ),
    GetPage(
        name: routeImageView,
        page: () => TKDismiss(
            ImageView(imageViewModel: Get.arguments as ImageViewModel))),
    GetPage(
        name: routePdfView,
        page: () => TKDismiss(PdfView(url: Get.arguments as String))),
    GetPage(name: routeBothSignature, page: () => TKDismiss(BothSignature())),
    GetPage(name: routeVisitCheckout, page: () => TKDismiss(VisitCheckout())),
    GetPage(name: routeRejectJob, page: () => const TKDismiss(RejectJob())),
    GetPage(name: routeNoAccess, page: () => const TKDismiss(NoAccess())),
  ];
}

// Tap Keyboard dismiss
class TKDismiss extends StatelessWidget {
  const TKDismiss(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(child: child);
  }
}
