// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagram_node_mode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiagramNodeModeAdapter extends TypeAdapter<DiagramNodeMode> {
  @override
  final int typeId = 4;

  @override
  DiagramNodeMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DiagramNodeMode.UNCHOOSE;
      case 1:
        return DiagramNodeMode.ENTRY;
      case 2:
        return DiagramNodeMode.LIB;
      case 3:
        return DiagramNodeMode.SHELVES;
      default:
        return DiagramNodeMode.UNCHOOSE;
    }
  }

  @override
  void write(BinaryWriter writer, DiagramNodeMode obj) {
    switch (obj) {
      case DiagramNodeMode.UNCHOOSE:
        writer.writeByte(0);
        break;
      case DiagramNodeMode.ENTRY:
        writer.writeByte(1);
        break;
      case DiagramNodeMode.LIB:
        writer.writeByte(2);
        break;
      case DiagramNodeMode.SHELVES:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiagramNodeModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
