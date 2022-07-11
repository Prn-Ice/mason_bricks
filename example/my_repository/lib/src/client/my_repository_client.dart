import 'package:dio/dio.dart';
import 'package:my_repository/my_repository.dart';
import 'package:retrofit/retrofit.dart';

part 'my_repository_client.g.dart';

@RestApi()
abstract class MyRepositoryClient {
  factory MyRepositoryClient(Dio dio, {String baseUrl}) = _MyRepositoryClient;

  @GET('/user/me')
  Future<User> getUser();
}
