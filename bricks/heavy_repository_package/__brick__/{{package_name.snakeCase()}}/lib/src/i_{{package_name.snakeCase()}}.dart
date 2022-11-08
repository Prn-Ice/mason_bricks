part of '{{package_name.snakeCase()}}.dart';

/// An interface for {{package_name.pascalCase()}}
abstract class I{{package_name.pascalCase()}}{
  {{#methods}}
  /// A description for {{name}}
  TaskEither<String, {{{type}}}> {{name}}();
  {{/methods}}
  /// Cached data
  User? get userData;

  /// Stream of cached data
  DeferStream<User?> get userDataStream;
}
