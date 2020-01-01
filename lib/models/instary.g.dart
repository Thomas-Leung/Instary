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
      fields[0] as DateTime,
      fields[1] as String,
      fields[2] as String,
      fields[3] as double,
      fields[4] as double,
      fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Instary obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.happinessLv)
      ..writeByte(4)
      ..write(obj.tirednessLv)
      ..writeByte(5)
      ..write(obj.stressfulnessLv);
  }
}
