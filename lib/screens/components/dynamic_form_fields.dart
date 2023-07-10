import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:easy_certs/constants.dart';
import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/model/validation_model.dart';
import 'package:easy_certs/model/worksheet_data_submit_model.dart';
import 'package:easy_certs/model/worksheet_image_rendered_model.dart';
import 'package:easy_certs/theme/text_styles.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:developer' as devtools show log;
import '../../helper/app_colors.dart';
import '../../utils/extra_function.dart';
import 'input_with_inner_label.dart';
import 'large_button.dart';

class DynamicFormFields extends StatefulWidget {
  DynamicFormFields({
    Key? key,
    required this.index,
    required this.itemName,
    required this.expandedTileName,
    required this.type,
    required this.enabled,
    required this.title,
    required this.fieldKey,
    required this.defaultText,
    required this.required,
    required this.list_options,
    required this.expandedTileIndex,
  }) : super(key: key);

  int index, expandedTileIndex;
  String type, title, fieldKey, defaultText, expandedTileName, itemName;
  bool enabled, required;
  Map<String, String>? list_options;

  @override
  State<DynamicFormFields> createState() => _DynamicFormFieldsState();
}

class _DynamicFormFieldsState extends State<DynamicFormFields> {
  List myList = [];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(builder: (jobController) {
      if (widget.enabled) {
        if (widget.type == 'text') {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title.isEmpty ? "" : widget.title,
                  style: kTextStyle12Normal,
                ),
                SizedBox(
                  height: 10.h,
                ),
                InputWithInnerLabel(
                  initialText: checkValueIsAvailable(widget.fieldKey) == null
                      ? widget.defaultText.isEmpty
                          ? null
                          : widget.defaultText
                      : checkValueIsAvailable(widget.fieldKey),
                  onSaved: (String? newValue) {
                    jobController.addWorksheetDataSubmitModelList(
                      WorksheetDataSubmitModel(
                        f_name: widget.fieldKey,
                        f_type: widget.type,
                        f_value: newValue ?? "",
                      ),
                    );
                  },
                  onChanged: (newValue) {
                    WorksheetDataSubmitModel model = WorksheetDataSubmitModel(
                      f_name: widget.fieldKey,
                      f_type: widget.type,
                      f_value: newValue ?? "",
                    );
                    updateWorkSheetModelOrAddNewModel(model);
                    // jobController.addWorksheetDataSubmitModelList(
                    //   WorksheetDataSubmitModel(
                    //     f_name: widget.fieldKey,
                    //     f_type: widget.type,
                    //     f_value: newValue ?? "",
                    //   ),
                    // );
                  },
                  validator: (String? value) {
                    Map<String, Object> myMap = {
                      "expandedTileName": widget.expandedTileName,
                      "title": widget.title,
                    };
                    if (widget.required) {
                      return simpleValidator(
                        value,
                        "*${widget.title.isEmpty ? "This field" : widget.title} is required",
                        getMap: myMap,
                      );
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          );
        } else if (widget.type == 'textarea') {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title.isEmpty ? "" : widget.title,
                  style: kTextStyle12Normal,
                ),
                InputWithInnerLabel(
                  initialText:
                      widget.defaultText.isEmpty ? null : widget.defaultText,
                  // labelText: title.isEmpty ? null : title,
                  maxLines: 4,
                  onSaved: (String? newValue) {
                    jobController.addWorksheetDataSubmitModelList(
                      WorksheetDataSubmitModel(
                          f_name: widget.fieldKey,
                          f_type: widget.type,
                          f_value: newValue ?? ""),
                    );
                  },
                  validator: (String? value) {
                    Map<String, Object> myMap = {
                      "expandedTileName": widget.expandedTileName,
                      "title": widget.title,
                    };
                    if (widget.required) {
                      return simpleValidator(
                        value,
                        "*${widget.title.isEmpty ? "This field" : widget.title} is required",
                        getMap: myMap,
                      );
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          );
        } else if (widget.type == 'select') {
          return DynamicFormDropdownField(
            defaultText: widget.defaultText,
            index: widget.index,
            type: widget.type,
            enabled: widget.enabled,
            title: widget.title,
            fieldKey: widget.fieldKey,
            required: widget.required,
            list_options: widget.list_options,
            onSaved: (String? newValue) {
              jobController.addWorksheetDataSubmitModelList(
                WorksheetDataSubmitModel(
                    f_name: widget.fieldKey,
                    f_type: widget.type,
                    f_value: newValue?.toLowerCase() ?? ""),
              );
            },
            validator: (String? value) {
              if (widget.required) {
                if (widget.defaultText != widget.defaultText) {
                  Map<String, Object> myMap = {
                    "expandedTileName": widget.expandedTileName,
                    "title": widget.title,
                  };
                  return simpleValidator(
                    value,
                    "*${widget.title.isEmpty ? "This field" : widget.title} is required",
                    getMap: myMap,
                  );
                }
              } else {
                return null;
              }
            },
          );
        } else if (widget.type == 'date') {
          return DynamicFormDatePicker(
            index: widget.index,
            type: widget.type,
            enabled: widget.enabled,
            title: widget.title,
            fieldKey: widget.fieldKey,
            defaultText: widget.defaultText,
            required: widget.required,
            onSaved: (String? newValue) {
              jobController.addWorksheetDataSubmitModelList(
                WorksheetDataSubmitModel(
                    f_name: widget.fieldKey,
                    f_type: widget.type,
                    f_value: newValue ?? "1"),
              );
            },
            validator: (String? value) {
              if (widget.required) {
                Map<String, Object> myMap = {
                  "expandedTileName": widget.expandedTileName,
                  "title": widget.title,
                };
                return simpleValidator(
                  value,
                  "*${widget.title.isEmpty ? "This field" : widget.title} is required",
                  getMap: myMap,
                );
              } else {
                return null;
              }
            },
          );
        } else if (widget.type == 'image') {
          jobController.addWorksheetImageRenderedList(
            WorksheetImageRenderedModel(
              itemName: widget.itemName,
              expandedTitleName: widget.expandedTileName,
              imageTitle: widget.title,
              imageKey: widget.fieldKey,
              uploadUrl: "",
              filePath: "",
              isRequired: widget.required,
              isFilled: false,
            ),
          );
          return DynamicImagePicker(
            jobController: jobController,
            itemName: widget.itemName,
            expandedTileName: widget.expandedTileName,
            title: widget.title,
            fieldKey: widget.fieldKey,
            isRequired: widget.required,
          );
        } else if (widget.type == 'signature') {
          jobController.addWorksheetSignatureRenderedList(
            WorksheetImageRenderedModel(
              itemName: widget.itemName,
              expandedTitleName: widget.expandedTileName,
              imageTitle: widget.title,
              imageKey: widget.fieldKey,
              uploadUrl: "",
              filePath: "",
              isRequired: widget.required,
              isFilled: false,
            ),
          );
          return DynamicSignature(
            jobController: jobController,
            itemName: widget.itemName,
            expandedTileName: widget.expandedTileName,
            title: widget.title,
            fieldKey: widget.fieldKey,
            isRequired: widget.required,
          );
        } else {
          return const SizedBox();
        }
      } else {
        return const SizedBox();
      }
    });
  }
}

class DynamicSignature extends StatefulWidget {
  DynamicSignature({
    Key? key,
    required this.jobController,
    required this.itemName,
    required this.expandedTileName,
    required this.title,
    required this.fieldKey,
    required this.isRequired,
  }) : super(key: key);
  JobController jobController;
  String itemName, expandedTileName, title, fieldKey;
  bool isRequired;
  @override
  State<DynamicSignature> createState() => _DynamicSignatureState();
}

class _DynamicSignatureState extends State<DynamicSignature> {
  GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();
  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        buildShowModalBottomSheetSignature(
            context,
            SizedBox(
              height: 400.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                    child: Text(
                      "Signature",
                      style: kTextStyle16Bold,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        SfSignaturePad(
                          key: signaturePadKey,
                          minimumStrokeWidth: 1,
                          maximumStrokeWidth: 3,
                          strokeColor: Colors.black,
                          backgroundColor: AppColors.grey300,
                        ),
                        Positioned(
                          top: 20.h,
                          left: 20.w,
                          child: GestureDetector(
                            onTap: () {
                              if (signaturePadKey.currentState != null) {
                                signaturePadKey.currentState!.clear();
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.grey600,
                              child: const Icon(
                                Icons.refresh,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                    height: 80.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey300, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomLargeButton(
                          width: 140.w,
                          bgColor: AppColors.purple,
                          textColor: AppColors.white,
                          title: "CANCEL",
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        CustomLargeButton(
                          width: 140.w,
                          bgColor: AppColors.purple,
                          textColor: AppColors.white,
                          title: "OK",
                          onPressed: () async {
                            if (signaturePadKey.currentState != null) {
                              ui.Image image =
                                  await signaturePadKey.currentState!.toImage();
                              ByteData? byteData = await image.toByteData(
                                format: ui.ImageByteFormat.png,
                              );
                              String finalPath = "";
                              if (byteData != null) {
                                finalPath = await saveSignatureFileReturnPath(
                                    widget.fieldKey, byteData);
                              }
                              log("byteData = $byteData");
                              log("filePath is $finalPath");
                              widget.jobController
                                  .updateWorksheetSignatureRenderedList(
                                WorksheetImageRenderedModel(
                                  itemName: widget.itemName,
                                  expandedTitleName: widget.expandedTileName,
                                  imageTitle: widget.title,
                                  imageKey: widget.fieldKey,
                                  uploadUrl: "",
                                  filePath: finalPath,
                                  isRequired: widget.isRequired,
                                  isFilled: true,
                                ),
                              );
                              setState(() {
                                imageBytes = byteData!.buffer.asUint8List(
                                  byteData.offsetInBytes,
                                  byteData.lengthInBytes,
                                );
                              });
                            }
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Text(
            widget.title,
            style: kTextStyle12Normal,
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60.w,
                width: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(kBorderRadius8),
                ),
                child: imageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(kBorderRadius8),
                        child: Image.memory(
                          imageBytes!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.edit,
                        size: 30.w,
                        color: AppColors.grey600,
                      ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imageBytes != null)
                    InkWell(
                      onTap: () {
                        widget.jobController
                            .updateWorksheetSignatureRenderedList(
                          WorksheetImageRenderedModel(
                            itemName: widget.itemName,
                            expandedTitleName: widget.expandedTileName,
                            imageTitle: widget.title,
                            imageKey: widget.fieldKey,
                            uploadUrl: "",
                            filePath: "",
                            isRequired: widget.isRequired,
                            isFilled: false,
                          ),
                        );
                        setState(() {
                          imageBytes = null;
                        });
                      },
                      borderRadius: BorderRadius.circular(kBorderRadius8),
                      child: Container(
                        height: 40.w,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(kBorderRadius8),
                        ),
                        child: const Icon(
                          Icons.delete_forever,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  if (imageBytes != null)
                    SizedBox(
                      width: 10.w,
                    ),
                  Container(
                    height: 40.w,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(kBorderRadius8),
                    ),
                    child: Icon(
                      Icons.upload,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}

class DynamicImagePicker extends StatefulWidget {
  DynamicImagePicker({
    Key? key,
    required this.jobController,
    required this.itemName,
    required this.expandedTileName,
    required this.title,
    required this.fieldKey,
    required this.isRequired,
  }) : super(key: key);
  JobController jobController;
  String itemName, expandedTileName, title, fieldKey;
  bool isRequired;

  @override
  State<DynamicImagePicker> createState() => _DynamicImagePickerState();
}

class _DynamicImagePickerState extends State<DynamicImagePicker> {
  XFile? result;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        buildShowModalBottomSheet(context, () async {
          Get.back();
          result = await picker.pickImage(source: ImageSource.camera);
          if (result != null) {
            widget.jobController.updateWorksheetImageRenderedList(
              WorksheetImageRenderedModel(
                itemName: widget.itemName,
                expandedTitleName: widget.expandedTileName,
                imageTitle: widget.title,
                imageKey: widget.fieldKey,
                uploadUrl: "",
                filePath: result!.path,
                isRequired: widget.isRequired,
                isFilled: true,
              ),
            );
            setState(() {
              result;
            });
          }
        }, () async {
          Get.back();
          result = await picker.pickImage(source: ImageSource.gallery);
          if (result != null) {
            widget.jobController.updateWorksheetImageRenderedList(
              WorksheetImageRenderedModel(
                itemName: widget.itemName,
                expandedTitleName: widget.expandedTileName,
                imageTitle: widget.title,
                imageKey: widget.fieldKey,
                uploadUrl: "",
                filePath: result!.path,
                isRequired: widget.isRequired,
                isFilled: true,
              ),
            );
            setState(() {
              result;
            });
          }
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Text(
            widget.title,
            style: kTextStyle12Normal,
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60.w,
                width: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(kBorderRadius8),
                ),
                child: result == null
                    ? Icon(
                        Icons.image,
                        size: 60.w,
                        color: AppColors.grey600,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(kBorderRadius8),
                        child: Image.file(
                          File(result!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (result != null)
                    InkWell(
                      onTap: () {
                        widget.jobController.updateWorksheetImageRenderedList(
                          WorksheetImageRenderedModel(
                            itemName: widget.itemName,
                            expandedTitleName: widget.expandedTileName,
                            imageTitle: widget.title,
                            imageKey: widget.fieldKey,
                            uploadUrl: "",
                            filePath: result!.path,
                            isRequired: widget.isRequired,
                            isFilled: false,
                          ),
                        );
                        setState(() {
                          result = null;
                        });
                      },
                      borderRadius: BorderRadius.circular(kBorderRadius8),
                      child: Container(
                        height: 40.w,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(kBorderRadius8),
                        ),
                        child: const Icon(
                          Icons.delete_forever,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  if (result != null)
                    SizedBox(
                      width: 10.w,
                    ),
                  Container(
                      height: 40.w,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(kBorderRadius8),
                      ),
                      child: Icon(
                        Icons.upload,
                        color: AppColors.grey600,
                      )),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}

//Dynamic DropDown
class DynamicFormDropdownField extends StatefulWidget {
  DynamicFormDropdownField({
    super.key,
    required this.index,
    required this.type,
    required this.enabled,
    required this.title,
    required this.fieldKey,
    required this.required,
    required this.list_options,
    required this.onSaved,
    required this.validator,
    required this.defaultText,
  });

  int index;
  String type, title, fieldKey;
  String? defaultText;
  bool enabled, required;
  Map<String, String>? list_options;
  FormFieldValidator<String>? validator;
  FormFieldSetter<String>? onSaved;

  @override
  State<DynamicFormDropdownField> createState() =>
      _DynamicFormDropdownFieldState();
}

class _DynamicFormDropdownFieldState extends State<DynamicFormDropdownField> {
  String? selectedValue;

  @override
  void initState() {
    if (widget.defaultText != null && widget.defaultText != "") {
      // devtools.log("it's not null");
      // devtools.log(widget.defaultText.toString());
      // selectedValue = widget.defaultText;
    } else {
      // devtools.log("it's null");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.list_options != null
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title.isEmpty ? "" : widget.title,
                  style: kTextStyle12Normal,
                ),
                SizedBox(
                  height: 10.h,
                ),
                DropdownButtonFormField(
                  value: selectedValue,
                  onSaved: widget.onSaved,
                  validator: widget.validator,
                  hint: Text(
                    widget.defaultText == ""
                        ? "Select ${widget.title}"
                        : widget.defaultText ?? "",
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                  items: widget.list_options?.entries.map(
                    (item) {
                      return DropdownMenuItem(
                        value: item.value,
                        child: Text(item.value),
                      );
                    },
                  ).toList(),
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6200EE)),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(kBorderRadius8),
                  menuMaxHeight: 400.h,
                  onChanged: (newSelected) {
                    if (newSelected != null) {
                      setState(() {
                        selectedValue = newSelected;
                      });
                    }
                  },
                ),
                if (selectedValue != null && selectedValue!.isNotEmpty)
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedValue = null;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 10.w,
                      ),
                      child: const Text(
                        "Clear",
                        style: TextStyle(color: AppColors.red),
                      ),
                    ),
                  )
              ],
            ),
          )
        : const SizedBox();
  }
}

//Dynamic DatePicker
class DynamicFormDatePicker extends StatefulWidget {
  DynamicFormDatePicker({
    Key? key,
    required this.index,
    required this.type,
    required this.enabled,
    required this.title,
    required this.fieldKey,
    required this.defaultText,
    required this.required,
    required this.onSaved,
    required this.validator,
  }) : super(key: key);

  int index;
  String type, title, fieldKey, defaultText;
  bool enabled, required;
  FormFieldValidator<String>? validator;
  FormFieldSetter<String>? onSaved;

  @override
  State<DynamicFormDatePicker> createState() => _DynamicFormDatePickerState();
}

class _DynamicFormDatePickerState extends State<DynamicFormDatePicker> {
  TextEditingController controller = TextEditingController();
  String? dateSelected;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title.isEmpty ? "" : widget.title,
          style: kTextStyle12Normal,
        ),
        InputWithInnerLabel(
          controller: controller,
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          iconData: Icons.calendar_month,
          readOnly: true,
          suffixOnTap: () async {
            String? temp = await pickDateAndAssign(context, true, false);
            if (temp != null && temp.isNotEmpty) {
              setState(() {
                controller.text = temp.substring(0, 10);
                dateSelected = temp;
              });
            }
          },
          onTap: () async {
            String? temp = await pickDateAndAssign(context, true, false);
            if (temp != null && temp.isNotEmpty) {
              setState(() {
                controller.text = temp.substring(0, 10);
                //
                // controller.text =
                //     DateFormat.yMMMMd().format(DateTime.parse(temp)).toString();
                dateSelected = temp;
              });
            }
          },
          onChanged: (value) {},
          onSaved: widget.onSaved,
          validator: widget.validator,
        ),
        if (controller.text.isNotEmpty)
          InkWell(
            onTap: () {
              setState(() {
                controller.text = "";
                dateSelected = null;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 10.w,
              ),
              child: const Text(
                "Clear",
                style: TextStyle(color: AppColors.red),
              ),
            ),
          )
      ],
    );
  }

  Future<String?> pickDateAndAssign(
      BuildContext context, bool startFromToday, bool endDateToday) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: startFromToday ? DateTime.now() : DateTime(1900, 1),
        lastDate: endDateToday ? DateTime.now() : DateTime(2101));
    if (picked != null) {
      return picked.toString();
    } else {
      return null;
    }
  }
}
