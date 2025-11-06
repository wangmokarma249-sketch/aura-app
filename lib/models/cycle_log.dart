import 'package:hive/hive.dart';

part 'cycle_log.g.dart';

@HiveType(typeId: 2)
class CycleLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startDate;

  @HiveField(2)
  final DateTime? endDate;

  @HiveField(3)
  final String? notes;

  @HiveField(4)
  final List<String>? symptoms;

  CycleLog({
    required this.id,
    required this.startDate,
    this.endDate,
    this.notes,
    this.symptoms,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'notes': notes,
      'symptoms': symptoms,
    };
  }

  factory CycleLog.fromJson(Map<String, dynamic> json) {
    return CycleLog(
      id: json['id'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      notes: json['notes'],
      symptoms: json['symptoms'] != null ? List<String>.from(json['symptoms']) : null,
    );
  }
}
