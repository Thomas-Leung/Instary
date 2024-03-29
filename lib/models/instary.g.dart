// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstaryAdapter extends TypeAdapter<Instary> {
  @override
  final int typeId = 1;

  @override
  Instary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Instary(
      fields[0] as String,
      fields[1] as DateTime,
      fields[2] as String,
      fields[3] as String,
      fields[4] as double,
      fields[5] as double,
      fields[6] as double,
      (fields[7] as List).cast<String>(),
      fields[8] as DateTime?,
      fields[9] as DateTime?,
      (fields[10] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Instary obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.stressfulnessLv)
      ..writeByte(7)
      ..write(obj.mediaPaths)
      ..writeByte(8)
      ..write(obj.bedTime)
      ..writeByte(9)
      ..write(obj.wakeUpTime)
      ..writeByte(10)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
