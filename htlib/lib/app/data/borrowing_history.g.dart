// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrowing_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BorrowingHistoryAdapter extends TypeAdapter<BorrowingHistory> {
  @override
  final int typeId = 2;

  @override
  BorrowingHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BorrowingHistory(
      id: fields[0] as String,
      isbn: fields[1] as String,
      createAt: fields[2] as DateTime,
      endAt: fields[3] as DateTime,
      state: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BorrowingHistory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isbn)
      ..writeByte(2)
      ..write(obj.createAt)
      ..writeByte(3)
      ..write(obj.endAt)
      ..writeByte(4)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorrowingHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
