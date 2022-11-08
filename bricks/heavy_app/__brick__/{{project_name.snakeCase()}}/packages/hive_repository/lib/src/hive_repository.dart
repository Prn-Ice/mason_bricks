// ignore_for_file: overridden_fields, avoid_catching_errors
// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:hive/hive.dart';
import 'package:synchronized/synchronized.dart';

abstract class BaseHiveRepository<T> {
  BaseHiveRepository({required BoxBase<dynamic> box}) : _box = box;

  final BoxBase<dynamic> _box;
  static final _lock = Lock();

  /// Puts an [item] in the box at the given [key]
  Future<void> put(dynamic key, T item) async {
    if (_box.isOpen) {
      return _lock.synchronized(() => _box.put(key, _toJson(item)));
    }
  }

  /// Deletes an item at the given [key]
  Future<void> delete(dynamic key) async {
    if (_box.isOpen) {
      return _lock.synchronized(() => _box.delete(key));
    }
  }

  /// Returns a stream of  values
  Stream<T?> watch({dynamic key}) {
    if (_box.isOpen) {
      return _box.watch(key: key).map((event) {
        return _fromJson(event.value);
      });
    }

    return const Stream.empty();
  }

  /// Returns the number of items contained in the box
  int get count => _box.isOpen ? _box.length : 0;

  /// Removes all entries from the box.
  Future<void> clear() async {
    if (_box.isOpen) {
      return _lock.synchronized(_box.clear);
    }
  }

  /// Close this box
  void close() {
    if (_box.isOpen) {
      _box.close();
    }
  }

  /// Responsible for converting the `Map<String, dynamic>` representation
  /// of the model into a concrete instance of the model.
  T? fromJson(Map<String, dynamic> json);

  /// Responsible for converting a concrete instance of the model
  /// into the the `Map<String, dynamic>` representation.
  ///
  /// If [toJson] returns `null`, then nothing will be persisted.
  Map<String, dynamic>? toJson(T item);

  // FIXME:(Prn-Ice): Add tests for functions stolen from HydratedBloc
  T? _fromJson(dynamic json) {
    final dynamic traversedJson = _traverseRead(json);
    final castJson = _cast<Map<String, dynamic>>(traversedJson);

    return fromJson(castJson ?? <String, dynamic>{});
  }

  Map<String, dynamic>? _toJson(T item) {
    return _cast<Map<String, dynamic>>(_traverseWrite(toJson(item)).value);
  }

  dynamic _traverseRead(dynamic value) {
    if (value is Map) {
      return value.map<String, dynamic>((dynamic key, dynamic value) {
        return MapEntry<String, dynamic>(
          _cast<String>(key) ?? '',
          _traverseRead(value),
        );
      });
    }
    if (value is List) {
      for (var i = 0; i < value.length; i++) {
        value[i] = _traverseRead(value[i]);
      }
    }

    return value;
  }

  C? _cast<C>(dynamic x) => x is C ? x : null;

  _Traversed _traverseWrite(Object? value) {
    final dynamic traversedAtomicJson = _traverseAtomicJson(value);
    if (traversedAtomicJson is! NIL) {
      return _Traversed.atomic(traversedAtomicJson);
    }
    final dynamic traversedComplexJson = _traverseComplexJson(value);
    if (traversedComplexJson is! NIL) {
      return _Traversed.complex(traversedComplexJson);
    }
    try {
      _checkCycle(value);
      final dynamic customJson = _toEncodable(value);
      final dynamic traversedCustomJson = _traverseJson(customJson);
      if (traversedCustomJson is NIL) {
        throw HydratedUnsupportedError(value);
      }
      _removeSeen(value);

      return _Traversed.complex(traversedCustomJson);
    } on HydratedCyclicError catch (e) {
      // ignore: avoid-throw-in-catch-block
      throw HydratedUnsupportedError(value, cause: e);
    } on HydratedUnsupportedError {
      rethrow; // do not stack `HydratedUnsupportedError`
    } catch (e) {
      // ignore: avoid-throw-in-catch-block
      throw HydratedUnsupportedError(value, cause: e);
    }
  }

  dynamic _traverseAtomicJson(dynamic object) {
    if (object is num) {
      if (!object.isFinite) {
        return const NIL();
      }

      return object;
    } else if (identical(object, true)) {
      return true;
    } else if (identical(object, false)) {
      return false;
    } else if (object == null) {
      return null;
    } else if (object is String) {
      return object;
    }

    return const NIL();
  }

  dynamic _traverseComplexJson(dynamic object) {
    if (object is List) {
      if (object.isEmpty) return object;
      _checkCycle(object);
      List<dynamic>? list;
      for (var i = 0; i < object.length; i++) {
        final traversed = _traverseWrite(object[i]);
        list ??= traversed.outcome == _Outcome.atomic
            ? object.sublist(0)
            : (<dynamic>[]..length = object.length);
        list[i] = traversed.value;
      }
      _removeSeen(object);

      return list;
    } else if (object is Map) {
      _checkCycle(object);
      final map = <String, dynamic>{};
      object.forEach((dynamic key, dynamic value) {
        final castKey = _cast<String>(key);
        if (castKey != null) {
          map[castKey] = _traverseWrite(value).value;
        }
      });
      _removeSeen(object);

      return map;
    }

    return const NIL();
  }

  dynamic _traverseJson(dynamic object) {
    final dynamic traversedAtomicJson = _traverseAtomicJson(object);

    return traversedAtomicJson is! NIL
        ? traversedAtomicJson
        : _traverseComplexJson(object);
  }

  // ignore: avoid_dynamic_calls
  dynamic _toEncodable(dynamic object) => object.toJson();

  final List<dynamic> _seen = <dynamic>[];

  void _checkCycle(Object? object) {
    for (var i = 0; i < _seen.length; i++) {
      if (identical(object, _seen[i])) {
        throw HydratedCyclicError(object);
      }
    }
    _seen.add(object);
  }

  void _removeSeen(dynamic object) {
    // ignore: prefer_asserts_with_message
    assert(_seen.isNotEmpty);
    // ignore: prefer_asserts_with_message
    assert(identical(_seen.last, object));
    _seen.removeLast();
  }
}

// Reports that an object could not be serialized due to cyclic references.
/// When the cycle is detected, a [HydratedCyclicError] is thrown.
class HydratedCyclicError extends HydratedUnsupportedError {
  /// The first object that was detected as part of a cycle.
  HydratedCyclicError(super.object);

  @override
  String toString() => 'Cyclic error while state traversing';
}

/// Reports that an object could not be serialized.
/// The [unsupportedObject] field holds object that failed to be serialized.
///
/// If an object isn't directly serializable, the serializer calls the `toJson`
/// method on the object. If that call fails, the error will be stored in the
/// [cause] field. If the call returns an object that isn't directly
/// serializable, the [cause] is null.
class HydratedUnsupportedError extends Error {
  /// The object that failed to be serialized.
  /// Error of attempt to serialize through `toJson` method.
  HydratedUnsupportedError(
    this.unsupportedObject, {
    this.cause,
  });

  /// The object that could not be serialized.
  final Object? unsupportedObject;

  /// The exception thrown when trying to convert the object.
  final Object? cause;

  @override
  String toString() {
    final safeString = Error.safeToString(unsupportedObject);
    final prefix = cause != null
        ? 'Converting object to an encodable object failed:'
        : 'Converting object did not return an encodable object:';

    return '$prefix $safeString';
  }
}

class NIL {
  const NIL();
}

enum _Outcome { atomic, complex }

class _Traversed {
  _Traversed._({required this.outcome, required this.value});
  _Traversed.atomic(dynamic value)
      : this._(outcome: _Outcome.atomic, value: value);
  _Traversed.complex(dynamic value)
      : this._(outcome: _Outcome.complex, value: value);
  final _Outcome outcome;
  final dynamic value;
}

abstract class HiveRepository<T> extends BaseHiveRepository<T> {
  HiveRepository({required Box<dynamic> box})
      : _box = box,
        super(box: box);

  @override
  final Box<dynamic> _box;

  /// Returns an optional wrapping a single item, found (or not) by [key]
  T? get(dynamic key) {
    return _box.isOpen ? _fromJson(_box.get(key)) : null;
  }
}

/// A repository of type T backed by a lazy hive box
abstract class LazyHiveRepository<T> extends BaseHiveRepository<T> {
  LazyHiveRepository({required LazyBox<dynamic> box})
      : _box = box,
        super(box: box);

  @override
  final LazyBox<dynamic> _box;

  /// Returns an optional wrapping a single item, found (or not) by [key]
  Future<T?> get(dynamic key) async {
    final dynamic value = await _box.get(key);

    return _box.isOpen ? _fromJson(value) : null;
  }
}
