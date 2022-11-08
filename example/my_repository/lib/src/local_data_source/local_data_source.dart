import 'package:hive_repository/hive_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'package:my_repository/my_repository.dart';

class LocalDataSource extends HiveRepository<User> {
  LocalDataSource({required super.box});

  static const String key = '__my_repository__';

  User? get user => get(key);

  DeferStream<User?> get userStream {
    return DeferStream(() {
      return watch(key: key).shareValueSeeded(user);
    });
  }

  @override
  User? fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(User item) {
    return item.toJson();
  }
}
