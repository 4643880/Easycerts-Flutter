import 'package:easy_certs/helper/app_assets.dart';
import 'package:easy_certs/helper/app_colors.dart';
import 'package:easy_certs/utils/extra_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import '../../constants.dart';
import '../../controller/auth_controller.dart';
import '../../helper/api.dart';
import '../../helper/app_texts.dart';
import '../../helper/hive_boxes.dart';
import '../../utils/util.dart';
import '../components/input_with_inner_label.dart';
import '../components/large_button.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  RxInt clickCount = 0.obs;

  String email = "", password = "";
  RxBool isObscure = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 90.h,
                ),
                SizedBox(
                  height: 200.h,
                  child: Center(
                      child: GestureDetector(
                    onTap: () async {
                      if (clickCount.value < 10) {
                        clickCount.value++;
                      } else if (clickCount.value >= 10) {
                        final currentWorkingUrlBox =
                            Boxes.getCurrentWorkingUrl();
                        clickCount.value = 0;
                        if (ApiHelper.baseUrl == kLiveBaseUrl) {
                          setState(() {
                            ApiHelper.baseUrl = kDevBaseUrl;
                          });
                          await currentWorkingUrlBox.put(
                              AppTexts.hiveCurrentWorkingUrl, kDevBaseUrl);
                          Util.showToast(
                              "In  Developer Mode. ${ApiHelper.baseUrl}");
                        } else {
                          setState(() {
                            ApiHelper.baseUrl = kLiveBaseUrl;
                          });
                          await currentWorkingUrlBox.put(
                            AppTexts.hiveCurrentWorkingUrl,
                            kLiveBaseUrl,
                          );
                          Util.showToast(
                              "Exiting Developer Mode. ${ApiHelper.baseUrl}");
                        }
                      }
                    },
                    child: Image.asset(
                      AppAssets.logoImg,
                      fit: BoxFit.contain,
                    ),
                  )),
                ),
                SizedBox(
                  height: 90.h,
                ),
                InputWithInnerLabel(
                  initialText: "sidrawazir393@gmail.com",
                  labelText: AppTexts.email,
                  maxLines: 1,
                  onSaved: (String? newValue) {
                    if (newValue != null) {
                      email = newValue;
                    }
                  },
                  validator: (value) {
                    return emailValidator(value, "*Email is invalid");
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                Obx(
                  () => InputWithInnerLabel(
                    initialText: "admin1234",
                    labelText: AppTexts.password,
                    obscureText: isObscure.value,
                    maxLines: 1,
                    iconData: isObscure.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    suffixOnTap: () {
                      isObscure.value = isObscure.value ? false : true;
                    },
                    onSaved: (String? newValue) {
                      if (newValue != null) {
                        password = newValue;
                      }
                    },
                    validator: (String? value) {
                      return passwordValidator(value, "*Password is invalid");
                    },
                  ),
                ),
                // TextButton(
                //   onPressed: () {},
                //   child: Text(
                //     AppTexts.forgetPassword,
                //     style:
                //         kTextStyle12Normal.copyWith(color: AppColors.secondary),
                //   ),
                // ),
                // SizedBox(
                //   height: 20.h,
                // ),
                SizedBox(
                  height: 50.h,
                ),
                CustomLargeButton(
                  title: 'Login'.toUpperCase(),
                  bgColor: AppColors.success,
                  textColor: AppColors.white,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Util.showLoading("Verification");
                      AuthController authController = Get.find();
                      bool temp =
                          await authController.loginWithApi(email, password);
                      if (temp) {
                        Util.dismiss();
                        await Get.find<AuthController>().saveToken();
                        Get.toNamed(routeDashboard);
                      } else {
                        Util.dismiss();
                      }
                    }
                  },
                ),
                if (ApiHelper.baseUrl == kDevBaseUrl)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100.h),
                      child: const Text("In Developer Mode"),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
