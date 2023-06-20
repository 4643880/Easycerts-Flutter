import 'package:hive/hive.dart';
part 'worksheet_data_submit_model.g.dart'; // this will generate models

// then use this command in terminal => flutter packages pub run build_runner build
// above command will automatically generate adapter of the new model
// flutter_hive provides listenable to show in real time
@HiveType(typeId: 5)
class WorksheetDataSubmitModel {
  @HiveField(0)
  String f_name;
  @HiveField(1)
  String f_type;
  @HiveField(2)
  String f_value;

  WorksheetDataSubmitModel({
    required this.f_name,
    required this.f_type,
    required this.f_value,
  });
}
