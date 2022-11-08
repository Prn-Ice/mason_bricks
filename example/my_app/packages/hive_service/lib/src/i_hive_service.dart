import 'package:hive/hive.dart';

abstract class IHiveService {
  /// Fetch a hive box, if the request fails, initialize hive and try again.
  Future<Box<dynamic>> get box;

  /// Initialize hive and open a box.
  Future<void> initializeHive();
}
