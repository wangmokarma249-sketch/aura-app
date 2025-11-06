import 'package:hive_flutter/hive_flutter.dart';
import '../models/step_log.dart';
import '../models/water_log.dart';
import '../models/cycle_log.dart';
import '../models/gut_log.dart';

class StorageService {
  static const String stepBoxName = 'steps';
  static const String waterBoxName = 'water';
  static const String cycleBoxName = 'cycle';
  static const String gutBoxName = 'gut';

  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(StepLogAdapter());
    Hive.registerAdapter(WaterLogAdapter());
    Hive.registerAdapter(CycleLogAdapter());
    Hive.registerAdapter(GutLogAdapter());

    await Hive.openBox<StepLog>(stepBoxName);
    await Hive.openBox<WaterLog>(waterBoxName);
    await Hive.openBox<CycleLog>(cycleBoxName);
    await Hive.openBox<GutLog>(gutBoxName);
  }

  static Box<StepLog> getStepBox() => Hive.box<StepLog>(stepBoxName);
  static Box<WaterLog> getWaterBox() => Hive.box<WaterLog>(waterBoxName);
  static Box<CycleLog> getCycleBox() => Hive.box<CycleLog>(cycleBoxName);
  static Box<GutLog> getGutBox() => Hive.box<GutLog>(gutBoxName);

  static Future<void> saveStepLog(StepLog log) async {
    final box = getStepBox();
    await box.put(log.id, log);
  }

  static Future<void> saveWaterLog(WaterLog log) async {
    final box = getWaterBox();
    await box.put(log.id, log);
  }

  static Future<void> saveCycleLog(CycleLog log) async {
    final box = getCycleBox();
    await box.put(log.id, log);
  }

  static Future<void> saveGutLog(GutLog log) async {
    final box = getGutBox();
    await box.put(log.id, log);
  }

  static List<StepLog> getStepLogs({int? limit}) {
    final box = getStepBox();
    final logs = box.values.toList();
    logs.sort((a, b) => b.date.compareTo(a.date));
    return limit != null ? logs.take(limit).toList() : logs;
  }

  static List<WaterLog> getWaterLogs({int? limit}) {
    final box = getWaterBox();
    final logs = box.values.toList();
    logs.sort((a, b) => b.date.compareTo(a.date));
    return limit != null ? logs.take(limit).toList() : logs;
  }

  static List<CycleLog> getCycleLogs({int? limit}) {
    final box = getCycleBox();
    final logs = box.values.toList();
    logs.sort((a, b) => b.startDate.compareTo(a.startDate));
    return limit != null ? logs.take(limit).toList() : logs;
  }

  static List<GutLog> getGutLogs({int? limit}) {
    final box = getGutBox();
    final logs = box.values.toList();
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return limit != null ? logs.take(limit).toList() : logs;
  }

  static StepLog? getTodayStepLog() {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return getStepBox().get(dateKey);
  }

  static WaterLog? getTodayWaterLog() {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return getWaterBox().get(dateKey);
  }

  static Future<void> clearAll() async {
    await getStepBox().clear();
    await getWaterBox().clear();
    await getCycleBox().clear();
    await getGutBox().clear();
  }
}
