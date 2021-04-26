// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      id: fields[0] as String?,
      isbn: fields[1] as String,
      name: fields[2] as String,
      publisher: fields[3] as String,
      year: fields[4] as int,
      price: fields[5] as int,
      type: (fields[6] as List?)?.cast<String>(),
      quantity: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isbn)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.publisher)
      ..writeByte(4)
      ..write(obj.year)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
