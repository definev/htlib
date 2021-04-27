// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagram_node.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiagramNodeAdapter extends TypeAdapter<DiagramNode> {
  @override
  final int typeId = 3;

  @override
  DiagramNode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiagramNode(
      fields[0] as String,
      label: fields[5] as String,
      bookList: (fields[6] as List).cast<String>(),
      mode: fields[7] as DiagramNodeMode,
      up: fields[1] as String?,
      left: fields[2] as String?,
      down: fields[3] as String?,
      right: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DiagramNode obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.up)
      ..writeByte(2)
      ..write(obj.left)
      ..writeByte(3)
      ..write(obj.down)
      ..writeByte(4)
      ..write(obj.right)
      ..writeByte(5)
      ..write(obj.label)
      ..writeByte(6)
      ..write(obj.bookList)
      ..writeByte(7)
      ..write(obj.mode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiagramNodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
