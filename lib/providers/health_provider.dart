import 'package:flutter/material.dart';
import '../models/health_metrics.dart';
import '../models/user_data.dart';

class HealthProvider with ChangeNotifier {
  HealthMetrics _metrics = HealthMetrics(
    date: DateTime.now(),
    steps: 7542,
    stepsGoal: 10000,
    waterCups: 6,
    waterGoal: 8,
    cycleDay: 12,
    gutHealthStatus: 'Good',
  );

  UserData _userData = UserData(
    name: 'Guest User',
    age: 25,
    height: 170.0,
    weight: 70.0,
    gender: 'Other',
  );

  HealthMetrics get metrics => _metrics;
  UserData get userData => _userData;

  void updateSteps(int steps) {
    _metrics = _metrics.copyWith(steps: steps);
    notifyListeners();
  }

  void updateStepsGoal(int goal) {
    _metrics = _metrics.copyWith(stepsGoal: goal);
    notifyListeners();
  }

  void addWaterCup() {
    if (_metrics.waterCups < _metrics.waterGoal) {
      _metrics = _metrics.copyWith(waterCups: _metrics.waterCups + 1);
      notifyListeners();
    }
  }

  void removeWaterCup() {
    if (_metrics.waterCups > 0) {
      _metrics = _metrics.copyWith(waterCups: _metrics.waterCups - 1);
      notifyListeners();
    }
  }

  void updateWaterGoal(int goal) {
    _metrics = _metrics.copyWith(waterGoal: goal);
    notifyListeners();
  }

  void updateCycleDay(int day) {
    _metrics = _metrics.copyWith(cycleDay: day);
    notifyListeners();
  }

  void updateGutHealthStatus(String status) {
    _metrics = _metrics.copyWith(gutHealthStatus: status);
    notifyListeners();
  }

  void addNote(String note) {
    _metrics = _metrics.copyWith(notes: note);
    notifyListeners();
  }

  void updateUserData(UserData data) {
    _userData = data;
    notifyListeners();
  }
}
