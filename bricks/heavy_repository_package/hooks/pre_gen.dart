import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final methods = _generateMethods(context);

  final flutterVar = context.vars['flutter'];
  final isFlutterService = (flutterVar == 'true') || (flutterVar == true);
  final notFlutter = isFlutterService == false;

  context.vars = {
    ...context.vars,
    'methods': methods,
    'notFlutter': notFlutter,
  };
}

List<Map<String, dynamic>>? _generateMethods(HookContext context) {
  final logger = context.logger;

  final singletonType = context.vars['singleton_type'].toString().toLowerCase();
  final isFactory = singletonType == 'factory-singleton';
  final isInstance = singletonType == 'static-instance-singleton';
  final isInstanceLazy = singletonType == 'static-instance-lazy-singleton';
  final isNone = singletonType == 'none';

  context.vars = {
    ...context.vars,
    'isFactory': isFactory,
    'isInstance': isInstance,
    'isInstanceLazy': isInstanceLazy,
    'isNone': isNone,
  };

  if (!logger.confirm(
    '? Do you want to add methods to your service?',
    defaultValue: true,
  )) {
    return null;
  }

  logger.alert(lightYellow.wrap('enter "e" to exit adding methods'));
  logger.alert('Format: returnType methodName e.g, String myMethod:');
  final methods = <Map<String, dynamic>>[];

  while (true) {
    final method = logger.prompt(':').replaceAll(RegExp('\\s+'), ' ').trim();
    if (method.toLowerCase() == 'e') {
      break;
    }

    if (!method.contains(' ')) {
      logger.alert(
          'That was not a valid format -> returnType methodName e.g, String myMethod');
      continue;
    }

    final splitProperty = method.split(' ');
    final propertyType = splitProperty[0];
    final propertyName = splitProperty[1];
    methods.add({
      'name': propertyName,
      'type': propertyType,
    });
  }

  return methods;
}
