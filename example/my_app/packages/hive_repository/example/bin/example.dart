import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:hive_repository/hive_repository.dart';
import 'package:rxdart/rxdart.dart';

Future<void> main(List<String> arguments) async {
  Hive.init('./');

  final box = await Hive.openBox<dynamic>('test');

  final repository = _StringRepository(box: box);

  UsingStream<String?, _StringRepository>(
    () => repository,
    (r) => r.watch(key: 'key'),
    (r) => r.close(),
  ).listen((value) => log(value.toString()));

  await repository.put('key', 'item 1');
  await Future<void>.delayed(const Duration(seconds: 1));
  await repository.put('key', 'item 2');
  await Future<void>.delayed(const Duration(seconds: 1));
  await repository.put('key', 'item 3');
  await Future<void>.delayed(const Duration(seconds: 1));
  await repository.put('key', 'item 4');
  await Future<void>.delayed(const Duration(seconds: 1));
  await repository.put('key', 'item 5');

  await Future<void>.delayed(const Duration(seconds: 1));
  await box.deleteFromDisk();
}

// ignore: prefer-match-file-name
class _StringRepository extends HiveRepository<String> {
  _StringRepository({required super.box});

  @override
  String fromJson(Map<String, dynamic> json) {
    return json['value'] as String;
  }

  @override
  Map<String, dynamic>? toJson(String item) {
    return <String, dynamic>{'value': item};
  }
}
