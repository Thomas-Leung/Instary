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
      fields[1] as DateTime,
      fields[2] as String,
      fields[3] as String,
      fields[4] as double,
      fields[5] as double,
      fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Instary obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.happinessLv)
      ..writeByte(5)
      ..write(obj.tirednessLv)
      ..writeByte(6)
      ..write(obj.stressfulnessLv);
  }
}
