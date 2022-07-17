// ignore_for_file: avoid_dynamic_calls

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

class LoggerBlocObserver extends BlocObserver {
  LoggerBlocObserver({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);

    final message = 'onEvent - ${bloc.runtimeType} $event';

    _logger.i(message);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    final message = 'onChange - ${bloc.runtimeType} \n'
        'CurrentState: ${change.currentState} \n'
        'NextState: ${change.nextState}';

    _logger.i(message);
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);

    final message = '${bloc.runtimeType} created';

    _logger.i(message);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);

    final message = '${bloc.runtimeType} closed';

    _logger.i(message);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    _logger.e('${bloc.runtimeType}', error, stackTrace);
  }
}
