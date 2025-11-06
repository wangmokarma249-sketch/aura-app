import 'package:hive/hive.dart';

part 'step_log.g.dart';

@HiveType(typeId: 0)
class StepLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int steps;

  @HiveField(3)
  final int goal;

  StepLog({
    required this.id,
    required this.date,
    required this.steps,
    required this.goal,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'steps': steps,
      'goal': goal,
    };
  }

  factory StepLog.fromJson(Map<String, dynamic> json) {
    return StepLog(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      steps: json['steps'] ?? 0,
      goal: json['goal'] ?? 10000,
    );
  }
}
