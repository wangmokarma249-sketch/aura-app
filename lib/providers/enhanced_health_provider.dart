import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../models/health_metrics.dart';
import '../models/user_data.dart';
import '../models/step_log.dart';
import '../models/water_log.dart';
import '../models/cycle_log.dart';
import '../models/gut_log.dart';
import '../services/step_service.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class EnhancedHealthProvider with ChangeNotifier {
  final StepService _stepService = StepService();
  StreamSubscription<int>? _stepSubscription;

  HealthMetrics _metrics = HealthMetrics(
    date: DateTime.now(),
    steps: 0,
    stepsGoal: 10000,
    waterCups: 0,
    waterGoal: 8,
    cycleDay: 1,
    gutHealthStatus: 'Good',
  );

  UserData _userData = UserData(
    name: 'Guest User',
    age: 25,
    height: 170.0,
    weight: 70.0,
    gender: 'Other',
  );

  DateTime? _timerStartTime;
  Timer? _gutTimer;
  int _gutTimerSeconds = 0;

  bool _hasStepPermission = false;
  bool _isStepTracking = false;

  HealthMetrics get metrics => _metrics;
  UserData get userData => _userData;
  bool get hasStepPermission => _hasStepPermission;
  bool get isStepTracking => _isStepTracking;
  bool get isTimerRunning => _timerStartTime != null;
  int get gutTimerSeconds => _gutTimerSeconds;

  Future<void> initialize() async {
    await _loadUserPreferences();
    await _loadTodayData();
    await _initializeStepTracking();
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _metrics = _metrics.copyWith(
      stepsGoal: prefs.getInt('steps_goal') ?? 10000,
      waterGoal: prefs.getInt('water_goal') ?? 8,
    );
  }

  Future<void> _loadTodayData() async {
    final stepLog = StorageService.getTodayStepLog();
    final waterLog = StorageService.getTodayWaterLog();

    if (stepLog != null) {
      _metrics = _metrics.copyWith(steps: stepLog.steps);
    }

    if (waterLog != null) {
      _metrics = _metrics.copyWith(waterCups: waterLog.cups);
    }

    final cycleLogs = StorageService.getCycleLogs(limit: 1);
    if (cycleLogs.isNotEmpty) {
      final lastCycle = cycleLogs.first;
      final daysSinceStart = DateTime.now().difference(lastCycle.startDate).inDays;
      _metrics = _metrics.copyWith(cycleDay: daysSinceStart + 1);
    }
  }

  Future<void> _initializeStepTracking() async {
    _hasStepPermission = await _stepService.requestPermission();

    if (_hasStepPermission) {
      await _stepService.initialize();
      final stream = _stepService.getStepStream();

      if (stream != null) {
        _isStepTracking = true;
        _stepSubscription = stream.listen((steps) {
          updateSteps(steps);
        });
      }
    }

    notifyListeners();
  }

  void updateSteps(int steps) {
    final oldSteps = _metrics.steps;
    _metrics = _metrics.copyWith(steps: steps);

    if (oldSteps < _metrics.stepsGoal && steps >= _metrics.stepsGoal) {
      NotificationService.showStepGoalAchieved();
      _vibrate();
    }

    _saveTodayStepLog();
    notifyListeners();
  }

  Future<void> updateStepsGoal(int goal) async {
    _metrics = _metrics.copyWith(stepsGoal: goal);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps_goal', goal);
    _saveTodayStepLog();
    notifyListeners();
  }

  Future<void> _saveTodayStepLog() async {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final log = StepLog(
      id: dateKey,
      date: today,
      steps: _metrics.steps,
      goal: _metrics.stepsGoal,
    );

    await StorageService.saveStepLog(log);
  }

  Future<void> addWaterCup() async {
    _metrics = _metrics.copyWith(waterCups: _metrics.waterCups + 1);
    await _saveTodayWaterLog();
    _vibrate();
    notifyListeners();
  }

  Future<void> removeWaterCup() async {
    if (_metrics.waterCups > 0) {
      _metrics = _metrics.copyWith(waterCups: _metrics.waterCups - 1);
      await _saveTodayWaterLog();
      notifyListeners();
    }
  }

  Future<void> updateWaterGoal(int goal) async {
    _metrics = _metrics.copyWith(waterGoal: goal);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('water_goal', goal);
    await _saveTodayWaterLog();
    notifyListeners();
  }

  Future<void> _saveTodayWaterLog() async {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final log = WaterLog(
      id: dateKey,
      date: today,
      cups: _metrics.waterCups,
      goal: _metrics.waterGoal,
    );

    await StorageService.saveWaterLog(log);
  }

  List<WaterLog> getWaterHistory() {
    return StorageService.getWaterLogs(limit: 7);
  }

  void updateCycleDay(int day) {
    _metrics = _metrics.copyWith(cycleDay: day);
    notifyListeners();
  }

  Future<void> startNewCycle({String? notes, List<String>? symptoms}) async {
    final log = CycleLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startDate: DateTime.now(),
      notes: notes,
      symptoms: symptoms,
    );

    await StorageService.saveCycleLog(log);
    _metrics = _metrics.copyWith(cycleDay: 1);
    notifyListeners();
  }

  List<CycleLog> getCycleHistory() {
    return StorageService.getCycleLogs(limit: 12);
  }

  DateTime? getPredictedNextCycle() {
    final logs = getCycleHistory();
    if (logs.length < 2) return null;

    int totalDays = 0;
    for (int i = 0; i < logs.length - 1; i++) {
      totalDays += logs[i].startDate.difference(logs[i + 1].startDate).inDays;
    }

    final averageCycleLength = totalDays ~/ (logs.length - 1);
    return logs.first.startDate.add(Duration(days: averageCycleLength));
  }

  void updateGutHealthStatus(String status) {
    _metrics = _metrics.copyWith(gutHealthStatus: status);
    notifyListeners();
  }

  void startGutTimer() {
    if (_timerStartTime != null) return;

    _timerStartTime = DateTime.now();
    _gutTimerSeconds = 0;

    _gutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _gutTimerSeconds++;
      notifyListeners();
    });

    _vibrate();
  }

  Future<void> stopGutTimer({String? notes}) async {
    if (_timerStartTime == null) return;

    _gutTimer?.cancel();
    _gutTimer = null;

    final log = GutLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: _timerStartTime!,
      durationSeconds: _gutTimerSeconds,
      notes: notes,
      comfortLevel: _metrics.gutHealthStatus,
    );

    await StorageService.saveGutLog(log);

    _timerStartTime = null;
    _gutTimerSeconds = 0;

    _vibrate();
    notifyListeners();
  }

  GutLog? getLastGutLog() {
    final logs = StorageService.getGutLogs(limit: 1);
    return logs.isNotEmpty ? logs.first : null;
  }

  List<GutLog> getGutHistory() {
    return StorageService.getGutLogs(limit: 30);
  }

  void addNote(String note) {
    _metrics = _metrics.copyWith(notes: note);
    notifyListeners();
  }

  void updateUserData(UserData data) {
    _userData = data;
    notifyListeners();
  }

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }
  }

  @override
  void dispose() {
    _stepSubscription?.cancel();
    _gutTimer?.cancel();
    _stepService.dispose();
    super.dispose();
  }
}
