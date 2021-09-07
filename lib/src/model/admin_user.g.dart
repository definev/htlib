// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdminTypeAdapter extends TypeAdapter<AdminType> {
  @override
  final int typeId = 6;

  @override
  AdminType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AdminType.librarian;
      case 1:
        return AdminType.mornitor;
      default:
        return AdminType.librarian;
    }
  }

  @override
  void write(BinaryWriter writer, AdminType obj) {
    switch (obj) {
      case AdminType.librarian:
        writer.writeByte(0);
        break;
      case AdminType.mornitor:
        writer.writeByte(1);
        break;
      case AdminType.tester:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AdminTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class AdminUserAdapter extends TypeAdapter<AdminUser> {
  @override
  final int typeId = 5;

  @override
  AdminUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdminUser(
      uid: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      phone: fields[3] as String,
      adminType: fields[7] as AdminType,
      className: fields[5] as String?,
      memberNumber: fields[6] as int?,
      activeMemberNumber: fields[8] as int?,
      imageUrl: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AdminUser obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.className)
      ..writeByte(6)
      ..write(obj.memberNumber)
      ..writeByte(7)
      ..write(obj.adminType)
      ..writeByte(8)
      ..write(obj.activeMemberNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AdminUserAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
