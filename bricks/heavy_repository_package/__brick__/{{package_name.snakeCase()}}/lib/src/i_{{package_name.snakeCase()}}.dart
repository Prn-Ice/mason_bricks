part of '{{package_name.snakeCase()}}.dart';

/// An interface for {{package_name.pascalCase()}}
abstract class I{{package_name.pascalCase()}}{ 
  static const String cacheKey = '__{{package_name.snakeCase()}}__';
  {{#methods}}
  /// A description for {{name}}
  TaskEither<String, {{{type}}}> {{name}}();
  {{/methods}}

  /// Cached data
  Future<User?> get userData;

  /// Stream of cached data
  Stream<User?> get userDataStream;
}
