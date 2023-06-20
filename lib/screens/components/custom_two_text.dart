import 'package:easy_certs/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTwoText extends StatelessWidget {
  CustomTwoText({
    Key? key,
    required this.first,
    required this.second,
    required this.applyPadding,
    required this.applyFlex,
  }) : super(key: key);
  final String first, second;
  bool applyPadding, applyFlex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: applyPadding
          ? EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h)
          : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: applyFlex ? 2 : 1,
              child: Text(
                first,
                textAlign: TextAlign.start,
                style: kTextStyle12Normal.copyWith(fontWeight: FontWeight.w400),
              )),
          Expanded(
            flex: 1,
            child: Text(
              second,
              textAlign: TextAlign.end,
              style: kTextStyle12Normal.copyWith(fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }
}
