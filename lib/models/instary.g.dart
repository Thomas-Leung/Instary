// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstaryAdapter extends TypeAdapter<Instary> {
  @override
  Instary read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Instary(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Instary obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content);
  }
}
