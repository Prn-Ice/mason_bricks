import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:{{package_name.snakeCase()}}/{{package_name.snakeCase()}}.dart';

part '{{package_name.snakeCase()}}_client.g.dart';

@RestApi()
abstract class {{package_name.pascalCase()}}Client {
  factory {{package_name.pascalCase()}}Client(Dio dio, {String baseUrl}) = _{{package_name.pascalCase()}}Client;

  @GET('/user/me')
  Future<User> getUser();
}
