import 'package:flutter/foundation.dart';

/// Clinical model representing a user-logged health record
class HealthRecord {
  final int age;
  final double height; // cm
  final double weight; // kg
  final int systolic; // mmHg
  final int diastolic; // mmHg
  final int heartRate; // BPM
  final double? bloodSugar; // mg/dL (optional)
  final DateTime timestamp;

  HealthRecord({
    required this.age,
    required this.height,
    required this.weight,
    required this.systolic,
    required this.diastolic,
    required this.heartRate,
    this.bloodSugar,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  double get bmi {
    if (height <= 0) return 0;
    final heightInMeters = height / 100.0;
    return weight / (heightInMeters * heightInMeters);
  }

  String get bloodPressureString => '$systolic/$diastolic';

  String get bmiCategory {
    final value = bmi;
    if (value < 18.5) return 'Underweight';
    if (value < 25.0) return 'Normal';
    if (value < 30.0) return 'Overweight';
    return 'Obese';
  }
}

/// Simple reactive service maintaining the latest logged vitals
class HealthDataService extends ChangeNotifier {
  HealthDataService._();
  static final HealthDataService instance = HealthDataService._();

  HealthRecord _latestRecord = HealthRecord(
    age: 28,
    height: 175.0,
    weight: 68.0,
    systolic: 120,
    diastolic: 80,
    heartRate: 72,
    bloodSugar: null,
  );

  final List<HealthRecord> _history = [];

  HealthRecord get latestRecord => _latestRecord;
  List<HealthRecord> get history => List.unmodifiable(_history);

  void saveRecord(HealthRecord record) {
    _latestRecord = record;
    _history.insert(0, record);
    notifyListeners();
  }
}
