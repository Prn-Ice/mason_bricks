import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_service/hive_service.dart';
import 'package:injectable/injectable.dart';
import 'package:{{#snakeCase}}{{project_name}}{{/snakeCase}}/app/router/router.dart';

@module
// ignore: prefer-match-file-name
abstract class InjectableModule {
  @lazySingleton
  AppRouter get router => AppRouter();

  @preResolve
  Future<Box<dynamic>> box(IHiveService hiveService) => hiveService.box;
}
