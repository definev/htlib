// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      name: fields[1] as String,
      currentClass: fields[2] as String,
      phone: fields[3] as String,
      status: fields[4] as String,
      image: fields[5] as String,
      borrowingBookList: (fields[6] as List)?.cast<String>(),
      borrowedHistoryList: (fields[7] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.currentClass)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.borrowingBookList)
      ..writeByte(7)
      ..write(obj.borrowedHistoryList);
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
