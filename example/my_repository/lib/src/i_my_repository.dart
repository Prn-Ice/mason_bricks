part of 'my_repository.dart';

/// An interface for MyRepository
abstract class IMyRepository{ 
  static const String cacheKey = '__my_repository__';
  
  /// A description for myUser
  TaskEither<String, User> myUser();
  

  /// Cached data
  Future<User?> get userData;

  /// Stream of cached data
  Stream<User?> get userDataStream;
}
