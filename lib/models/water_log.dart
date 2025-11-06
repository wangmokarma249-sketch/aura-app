import 'package:hive/hive.dart';

part 'water_log.g.dart';

@HiveType(typeId: 1)
class WaterLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int cups;

  @HiveField(3)
  final int goal;

  WaterLog({
    required this.id,
    required this.date,
    required this.cups,
    required this.goal,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'cups': cups,
      'goal': goal,
    };
  }

  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      cups: json['cups'] ?? 0,
      goal: json['goal'] ?? 8,
    );
  }
}
