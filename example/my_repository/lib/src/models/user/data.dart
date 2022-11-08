// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:freezed_annotation/freezed_annotation.dart';

part 'data.freezed.dart';
part 'data.g.dart';

// **************************************************************************
// FreezerGenerator
// **************************************************************************

@freezed
class Data with _$Data {
  const factory Data({
    String? firstName,
    String? lastName,
  }) = _Data;

  /// Returns [Data] based on [json].
  factory Data.fromJson(Map<String, Object?> json) => _$DataFromJson(json);
}
