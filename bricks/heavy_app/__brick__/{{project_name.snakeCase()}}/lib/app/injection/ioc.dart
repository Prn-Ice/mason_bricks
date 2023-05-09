import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:{{#snakeCase}}{{project_name}}{{/snakeCase}}/app/injection/ioc.config.dart';

final GetIt _getIt = GetIt.instance;


@InjectableInit(
  preferRelativeImports: true,
  asExtension: false,
  throwOnMissingDependencies: true,
)
Future<GetIt> configureDependencies({String? environment}) {
  return init(_getIt, environment: environment);
}

T resolve<T extends Object>() => _getIt<T>();

T resolveWithParameter<T extends Object, TP>({TP? parameter}) {
  return _getIt<T>(param1: parameter);
}

GetIt configureTestDependencies() {
  _getIt.reset();
  configureDependencies(environment: Environment.test);
  _getIt.allowReassignment = true;

  return _getIt;
}
