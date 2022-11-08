import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_service/hive_service.dart';

class HiveService implements IHiveService {
  HiveService({
    HiveInterface? hive,
    required String name,
  })  : _hive = hive ?? Hive,
        _name = name;

  final HiveInterface _hive;
  final String _name;

  @override
  Future<Box<dynamic>> get box async {
    try {
      return _hive.box<dynamic>(_name);
    } catch (e) {
      await initializeHive();

      return _hive.box<dynamic>(_name);
    }
  }

  @override
  Future<void> initializeHive() async {
    try {
      await _hive.initFlutter();
      await _hive.openBox<dynamic>(_name);
    } catch (e, s) {
      log('${e.toString()} unable to initialize hive', error: e, stackTrace: s);
    }
  }
}
