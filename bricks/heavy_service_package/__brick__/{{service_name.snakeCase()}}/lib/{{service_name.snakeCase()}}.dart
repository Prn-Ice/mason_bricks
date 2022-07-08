library {{service_name.snakeCase()}};
{{#hasModels}}
export 'src/models/models.dart';{{/hasModels}}
export 'src/{{service_name.snakeCase()}}.dart';