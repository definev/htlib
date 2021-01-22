// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrow_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BorrowHistoryAdapter extends TypeAdapter<BorrowHistory> {
  @override
  final int typeId = 2;

  @override
  BorrowHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BorrowHistory(
      isbn: fields[0] as String,
      createAt: fields[1] as DateTime,
      endAt: fields[2] as DateTime,
      state: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BorrowHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isbn)
      ..writeByte(1)
      ..write(obj.createAt)
      ..writeByte(2)
      ..write(obj.endAt)
      ..writeByte(3)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorrowHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
