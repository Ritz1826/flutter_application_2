// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserNotesAdapter extends TypeAdapter<UserNotes> {
  @override
  final int typeId = 1;

  @override
  UserNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserNotes(
      title: fields[0] as String,
      description: fields[1] as String,
      timeStamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserNotes obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.timeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
