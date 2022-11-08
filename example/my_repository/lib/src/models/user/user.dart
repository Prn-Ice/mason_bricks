// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:freezed_annotation/freezed_annotation.dart';

import 'data.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// **************************************************************************
// FreezerGenerator
// **************************************************************************

@freezed
class User with _$User {
  const factory User({
    String? status,
    String? message,
    Data? data,
  }) = _User;

  /// Returns [User] based on [json].
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
