import 'package:hive/hive.dart';

part 'timer_model.g.dart';

// this will generate models
// then use this command in terminal => flutter packages pub run build_runner build
// above command will automatically generate adapter of the new model
// flutter_hive provides listenable to show in real time

@HiveType(typeId: 8)
class TimerModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime? startTime;
  @HiveField(2)
  final DateTime? pauseTime;
  @HiveField(3)
  final DateTime? endTime;

  TimerModel({
    required this.id,
    this.startTime,
    this.pauseTime,
    this.endTime,
  });
}
