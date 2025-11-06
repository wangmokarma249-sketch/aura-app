import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepService {
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;

  int _initialSteps = 0;
  int _currentSteps = 0;
  bool _isInitialized = false;

  int get currentSteps => _currentSteps - _initialSteps;

  Future<bool> requestPermission() async {
    if (await Permission.activityRecognition.isGranted) {
      return true;
    }

    final status = await Permission.activityRecognition.request();
    return status.isGranted;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    final hasPermission = await requestPermission();
    if (!hasPermission) {
      return;
    }

    try {
      _stepCountStream = Pedometer.stepCountStream;
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
    }
  }

  Stream<int>? getStepStream() {
    if (!_isInitialized || _stepCountStream == null) {
      return null;
    }

    return _stepCountStream!.map((event) {
      if (_initialSteps == 0) {
        _initialSteps = event.steps;
      }
      _currentSteps = event.steps;
      return currentSteps;
    }).handleError((error) {
      return 0;
    });
  }

  Stream<String>? getPedestrianStatusStream() {
    if (!_isInitialized || _pedestrianStatusStream == null) {
      return null;
    }

    return _pedestrianStatusStream!.map((event) => event.status).handleError((error) {
      return 'unknown';
    });
  }

  void reset() {
    _initialSteps = _currentSteps;
  }

  void dispose() {
    _stepCountStream = null;
    _pedestrianStatusStream = null;
    _isInitialized = false;
  }
}
