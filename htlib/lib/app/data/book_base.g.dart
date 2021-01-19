// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_base.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookBaseAdapter extends TypeAdapter<BookBase> {
  @override
  final int typeId = 1;

  @override
  BookBase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookBase(
      id: fields[0] as int,
      name: fields[1] as String,
      location: fields[2] as String,
      year: fields[3] as int,
      price: fields[4] as int,
      type: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookBase obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookBaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
