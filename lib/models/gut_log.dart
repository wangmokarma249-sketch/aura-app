import 'package:hive/hive.dart';

part 'gut_log.g.dart';

@HiveType(typeId: 3)
class GutLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final int durationSeconds;

  @HiveField(3)
  final String? notes;

  @HiveField(4)
  final String comfortLevel;

  GutLog({
    required this.id,
    required this.timestamp,
    required this.durationSeconds,
    this.notes,
    this.comfortLevel = 'Good',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'duration_seconds': durationSeconds,
      'notes': notes,
      'comfort_level': comfortLevel,
    };
  }

  factory GutLog.fromJson(Map<String, dynamic> json) {
    return GutLog(
      id: json['id'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      durationSeconds: json['duration_seconds'] ?? 0,
      notes: json['notes'],
      comfortLevel: json['comfort_level'] ?? 'Good',
    );
  }

  String getFormattedDuration() {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}
