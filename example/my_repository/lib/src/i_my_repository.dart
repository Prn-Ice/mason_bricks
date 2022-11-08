part of 'my_repository.dart';

/// An interface for MyRepository
abstract class IMyRepository{
  
  /// A description for getUser
  TaskEither<String, String> getUser();
  
  /// Cached data
  User? get userData;

  /// Stream of cached data
  DeferStream<User?> get userDataStream;
}
