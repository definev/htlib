// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeTypeAdapter extends TypeAdapter<ThemeType> {
  @override
  final int typeId = 1;

  @override
  ThemeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeType.BlueHT;
      case 1:
        return ThemeType.BlueHT_Dark;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeType obj) {
    switch (obj) {
      case ThemeType.BlueHT:
        writer.writeByte(0);
        break;
      case ThemeType.BlueHT_Dark:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
