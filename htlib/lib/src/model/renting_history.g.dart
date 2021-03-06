// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renting_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RentingHistoryAdapter extends TypeAdapter<RentingHistory> {
  @override
  final int typeId = 1;

  @override
  RentingHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RentingHistory(
      id: fields[0] as String,
      borrowBy: fields[1] as String,
      isbnList: (fields[2] as List)?.cast<String>(),
      createAt: fields[3] as DateTime,
      endAt: fields[4] as DateTime,
      state: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RentingHistory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.borrowBy)
      ..writeByte(2)
      ..write(obj.isbnList)
      ..writeByte(3)
      ..write(obj.createAt)
      ..writeByte(4)
      ..write(obj.endAt)
      ..writeByte(5)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RentingHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
