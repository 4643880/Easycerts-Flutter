import 'dart:convert';

import 'package:easy_certs/controller/job_controller.dart';
import 'package:easy_certs/helper/hive_boxes.dart';
import 'package:easy_certs/model/worksheet_data_submit_model.dart';
import 'package:easy_certs/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/extra_function.dart';
import 'dynamic_form_fields.dart';
import 'dart:developer' as devtools show log;

class DynamicExpandedTiles extends StatefulWidget {
  DynamicExpandedTiles({
    Key? key,
    required this.index,
    required this.itemName,
    required this.sectionData,
  }) : super(key: key);
  int index;
  String itemName;
  dynamic sectionData;
  @override
  State<DynamicExpandedTiles> createState() => _DynamicExpandedTilesState();
}

class _DynamicExpandedTilesState extends State<DynamicExpandedTiles> {
  List myData = [];
  bool isLoading = false;

  @override
  void initState() {
    getDataFromLocalStorage();
    super.initState();
  }

  List<dynamic> temporaryList = [];
  getDataFromLocalStorage() async {
    Util.showLoading("Loading Data...");
    setState(() {
      isLoading = true;
    });
    temporaryList.clear();
    await funcToFechData();
    await Future.delayed(const Duration(seconds: 1));
    // devtools.log("2: " + DateTime.now().toString());
    if (mounted) {
      setState(() {
        myData = temporaryList;
        isLoading = false;
      });
    }
    Util.dismiss();
  }

  Future funcToFechData() async {
    List? listOfKeys = await Boxes.getKeysOfWorkSpaceData().get('keysOfList');
    // devtools.log(Boxes.getSavedWorkSpaceData().get(listOfKeys![0]).toString());
    listOfKeys?.forEach((element) async {
      final eachElement = await Boxes.getSavedWorkSpaceData().get(element);
      // devtools.log(eachElement.toString());
      temporaryList.add(eachElement);
      // devtools.log("1: " + DateTime.now().toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Util.dismiss();
    return ExpansionTile(
      maintainState: true,
      title: Text(widget.sectionData['name']),
      children: [
        if (widget.sectionData['data'].length != null &&
            widget.sectionData['data'].length > 0)
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.sectionData['data'].length,
            itemBuilder: (context, index) => DynamicFormFields(
              index: index,
              expandedTileIndex: widget.index,
              itemName: widget.itemName,
              expandedTileName: widget.sectionData['name'],
              type: widget.sectionData['data'][index]['type'] ?? "",
              enabled: widget.sectionData['data'][index]['enabled'] == "true"
                  ? true
                  : false,
              title: widget.sectionData['data'][index]['title'] ?? "",
              fieldKey: widget.sectionData['data'][index]['key'] ?? "",
              defaultText: widget.sectionData['data'][index]['default'] ?? "",
              required: widget.sectionData['data'][index]['required'] == "true"
                  ? true
                  : false,
              list_options:
                  widget.sectionData['data'][index]['list_options'] != null
                      ? setListOptions(
                          widget.sectionData['data'][index]['list_options'],
                        )
                      : null,
            ),
          ),
      ],
    );
  }
}
