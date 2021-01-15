// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompletedItemAdapter extends TypeAdapter<CompletedItem> {
  @override
  final int typeId = 6;

  @override
  CompletedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompletedItem(
      id: fields[0] as int,
      item: fields[1] as String,
      price: fields[2] as String,
      quantity: fields[3] as int,
      project: fields[4] as int,
      selected: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CompletedItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.item)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.project)
      ..writeByte(6)
      ..write(obj.selected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
