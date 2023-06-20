// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worksheet_data_submit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorksheetDataSubmitModelAdapter
    extends TypeAdapter<WorksheetDataSubmitModel> {
  @override
  final int typeId = 5;

  @override
  WorksheetDataSubmitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorksheetDataSubmitModel(
      f_name: fields[0] as String,
      f_type: fields[1] as String,
      f_value: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorksheetDataSubmitModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.f_name)
      ..writeByte(1)
      ..write(obj.f_type)
      ..writeByte(2)
      ..write(obj.f_value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorksheetDataSubmitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
