import 'package:crashlytics_service/crashlytics_service.dart';
import 'package:hive_service/hive_service.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ServiceModule {
  @lazySingleton
  CrashlyticsService get crashlyticsService => CrashlyticsService();

  @dev
  @Singleton(as: IHiveService)
  HiveService get devHiveService {
    return HiveService(name: '__app_data_dev__')..initializeHive();
  }

  @prod
  @Singleton(as: IHiveService)
  HiveService get hiveService {
    return HiveService(name: '__app_data__')..initializeHive();
  }
}
