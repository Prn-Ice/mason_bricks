import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'data.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    String? status,
    String? message,
    Data? data,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
