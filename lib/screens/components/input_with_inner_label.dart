import 'package:easy_certs/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helper/app_colors.dart';

class InputWithInnerLabel extends StatelessWidget {
  InputWithInnerLabel({
    Key? key,
    this.labelText,
    this.initialText,
    this.iconData,
    this.hintText,
    this.prefixText,
    this.textInputType,
    this.inputFormatters,
    required this.onSaved,
    required this.validator,
    this.onTap,
    this.readOnly,
    this.obscureText,
    this.enabled,
    this.suffixOnTap,
    this.controller,
    this.autovalidateMode,
    this.onChanged,
    this.maxLines,
    this.disableBorder,
  }) : super(key: key);
  final String? labelText;
  final String? initialText;
  final IconData? iconData;
  final String? hintText;
  final String? prefixText;
  final TextInputType? textInputType;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  bool? readOnly, obscureText, enabled, disableBorder;
  FormFieldValidator<String>? validator;
  FormFieldSetter<String>? onSaved;
  VoidCallback? onTap;
  VoidCallback? suffixOnTap;
  TextEditingController? controller;
  AutovalidateMode? autovalidateMode;
  void Function(String? text)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      enabled: enabled,
      initialValue: initialText,
      controller: controller,
      style: kTextStyle12Normal,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        hintText: hintText,
        prefixText: prefixText,
        suffixIcon: iconData != null
            ? Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: IconButton(
                  onPressed: suffixOnTap ?? () {},
                  splashRadius: 20.h,
                  icon: Icon(iconData),
                  color: AppColors.grey900,
                ),
              )
            : null,
        border: disableBorder == true
            ? null
            : const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6200EE)),
              ),
      ),
      readOnly: readOnly ?? false,
      onSaved: onSaved,
      validator: validator,
      onTap: onTap,
    );
  }
}
