// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel()
      .._id = fields[0] as int?
      .._name = fields[1] as String?
      .._firstName = fields[2] as String?
      .._lastName = fields[3] as String?
      .._email = fields[4] as String?
      .._approved = fields[5] as int?
      .._verified = fields[6] as int?
      .._verificationToken = fields[7] as String?
      .._createdAt = fields[8] as String?
      .._updatedAt = fields[9] as String?
      .._engineer = fields[10] as Engineer?;
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._name)
      ..writeByte(2)
      ..write(obj._firstName)
      ..writeByte(3)
      ..write(obj._lastName)
      ..writeByte(4)
      ..write(obj._email)
      ..writeByte(5)
      ..write(obj._approved)
      ..writeByte(6)
      ..write(obj._verified)
      ..writeByte(7)
      ..write(obj._verificationToken)
      ..writeByte(8)
      ..write(obj._createdAt)
      ..writeByte(9)
      ..write(obj._updatedAt)
      ..writeByte(10)
      ..write(obj._engineer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EngineerAdapter extends TypeAdapter<Engineer> {
  @override
  final int typeId = 1;

  @override
  Engineer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Engineer()
      .._id = fields[0] as int?
      .._gasSafeIdNumber = fields[1] as dynamic
      .._profilePhoto = fields[2] as String?
      .._mobileNumber = fields[3] as String?
      .._address = fields[4] as String?
      .._city = fields[5] as String?
      .._country = fields[6] as String?
      .._postalCode = fields[7] as String?
      .._lat = fields[8] as String?
      .._long = fields[9] as String?
      .._currentLat = fields[10] as String?
      .._currentLong = fields[11] as String?
      .._locationUpdatedAt = fields[12] as String?
      .._createdAt = fields[13] as String?
      .._updatedAt = fields[14] as String?;
  }

  @override
  void write(BinaryWriter writer, Engineer obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._gasSafeIdNumber)
      ..writeByte(2)
      ..write(obj._profilePhoto)
      ..writeByte(3)
      ..write(obj._mobileNumber)
      ..writeByte(4)
      ..write(obj._address)
      ..writeByte(5)
      ..write(obj._city)
      ..writeByte(6)
      ..write(obj._country)
      ..writeByte(7)
      ..write(obj._postalCode)
      ..writeByte(8)
      ..write(obj._lat)
      ..writeByte(9)
      ..write(obj._long)
      ..writeByte(10)
      ..write(obj._currentLat)
      ..writeByte(11)
      ..write(obj._currentLong)
      ..writeByte(12)
      ..write(obj._locationUpdatedAt)
      ..writeByte(13)
      ..write(obj._createdAt)
      ..writeByte(14)
      ..write(obj._updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EngineerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
