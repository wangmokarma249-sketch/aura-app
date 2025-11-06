class HealthMetrics {
  final String? id;
  final DateTime date;
  final int steps;
  final int stepsGoal;
  final int waterCups;
  final int waterGoal;
  final int cycleDay;
  final String gutHealthStatus;
  final String? notes;

  HealthMetrics({
    this.id,
    required this.date,
    required this.steps,
    required this.stepsGoal,
    required this.waterCups,
    required this.waterGoal,
    required this.cycleDay,
    required this.gutHealthStatus,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'steps': steps,
      'steps_goal': stepsGoal,
      'water_cups': waterCups,
      'water_goal': waterGoal,
      'cycle_day': cycleDay,
      'gut_health_status': gutHealthStatus,
      'notes': notes,
    };
  }

  factory HealthMetrics.fromJson(Map<String, dynamic> json) {
    return HealthMetrics(
      id: json['id'],
      date: DateTime.parse(json['date']),
      steps: json['steps'] ?? 0,
      stepsGoal: json['steps_goal'] ?? 10000,
      waterCups: json['water_cups'] ?? 0,
      waterGoal: json['water_goal'] ?? 8,
      cycleDay: json['cycle_day'] ?? 1,
      gutHealthStatus: json['gut_health_status'] ?? 'Good',
      notes: json['notes'],
    );
  }

  HealthMetrics copyWith({
    String? id,
    DateTime? date,
    int? steps,
    int? stepsGoal,
    int? waterCups,
    int? waterGoal,
    int? cycleDay,
    String? gutHealthStatus,
    String? notes,
  }) {
    return HealthMetrics(
      id: id ?? this.id,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      waterCups: waterCups ?? this.waterCups,
      waterGoal: waterGoal ?? this.waterGoal,
      cycleDay: cycleDay ?? this.cycleDay,
      gutHealthStatus: gutHealthStatus ?? this.gutHealthStatus,
      notes: notes ?? this.notes,
    );
  }
}
