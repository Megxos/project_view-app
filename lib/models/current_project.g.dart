// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentProjectAdapter extends TypeAdapter<CurrentProject> {
  @override
  final int typeId = 5;

  @override
  CurrentProject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentProject(
      id: fields[0] as int,
      name: fields[1] as String,
      owner: fields[3] as int,
      code: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentProject obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.owner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
