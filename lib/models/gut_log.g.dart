part of 'gut_log.dart';

class GutLogAdapter extends TypeAdapter<GutLog> {
  @override
  final int typeId = 3;

  @override
  GutLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GutLog(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      durationSeconds: fields[2] as int,
      notes: fields[3] as String?,
      comfortLevel: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GutLog obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.durationSeconds)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.comfortLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GutLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
