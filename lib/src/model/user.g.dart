// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      address: fields[1] as String,
      name: fields[2] as String,
      className: fields[3] as String,
      phone: fields[4] as String,
      status: fields[5] as String,
      imageUrl: fields[6] as String?,
      bookMap: (fields[7] as Map).cast<String, int>(),
      rentingHistoryList: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.className)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.bookMap)
      ..writeByte(8)
      ..write(obj.rentingHistoryList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
