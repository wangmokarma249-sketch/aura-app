part of 'water_log.dart';

class WaterLogAdapter extends TypeAdapter<WaterLog> {
  @override
  final int typeId = 1;

  @override
  WaterLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterLog(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      cups: fields[2] as int,
      goal: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WaterLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.cups)
      ..writeByte(3)
      ..write(obj.goal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
