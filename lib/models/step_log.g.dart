part of 'step_log.dart';

class StepLogAdapter extends TypeAdapter<StepLog> {
  @override
  final int typeId = 0;

  @override
  StepLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepLog(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      steps: fields[2] as int,
      goal: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StepLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.steps)
      ..writeByte(3)
      ..write(obj.goal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
