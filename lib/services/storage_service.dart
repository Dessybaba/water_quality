import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import '../models/water_quality_record.dart';

class StorageService extends ChangeNotifier {
  late Box<WaterQualityRecord> _recordsBox;

  List<WaterQualityRecord> _records = [];
  List<WaterQualityRecord> get records => _records;

  StorageService() {
    _initialize();
  }

  Future<void> _initialize() async {
    _recordsBox = Hive.box<WaterQualityRecord>('waterQualityRecords');
    loadRecords();
  }

  void loadRecords() {
    _records = _recordsBox.values.toList();
    _records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> saveRecord(WaterQualityRecord record) async {
    await _recordsBox.put(record.id, record);
    loadRecords();
  }

  Future<void> deleteRecord(String id) async {
    await _recordsBox.delete(id);
    loadRecords();
  }

  Future<void> updateRecord(WaterQualityRecord record) async {
    await _recordsBox.put(record.id, record);
    loadRecords();
  }

  WaterQualityRecord? getRecordById(String id) {
    try {
      return _recordsBox.get(id);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteAllRecords() async {
    await _recordsBox.clear();
    loadRecords();
  }
}
