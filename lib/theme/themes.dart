import 'package:flutter/material.dart';

import '../constants.dart';
import '../helper/app_colors.dart';

final ThemeData kAppTheme = ThemeData(
  colorScheme: kColorScheme,
  // fontFamily: kMontserrat,
);

OutlineInputBorder kInputFieldBorderStyle = OutlineInputBorder(
  borderRadius: BorderRadius.circular(kBorderRadius8),
  borderSide: const BorderSide(
    color: AppColors.inputBorder,
  ),
);
