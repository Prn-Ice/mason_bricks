import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:my_repository/my_repository.dart';

part 'my_repository_client.g.dart';

@RestApi()
abstract class MyRepositoryClient {
  factory MyRepositoryClient(Dio dio, {String baseUrl}) = _MyRepositoryClient;

  @GET('/user/me')
  Future<User> getUser();
}
