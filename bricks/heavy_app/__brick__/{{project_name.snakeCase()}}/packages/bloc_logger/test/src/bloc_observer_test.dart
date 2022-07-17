import 'package:bloc/bloc.dart';
import 'package:bloc_logger/src/bloc_observer.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLogger extends Mock implements Logger {}

class MockBloc extends Mock implements Bloc<dynamic, dynamic> {}

void main() {
  group('LoggerBlocObserver', () {
    late Logger logger;
    late Bloc<dynamic, dynamic> bloc;
    late LoggerBlocObserver observer;

    setUp(() {
      logger = MockLogger();
      observer = LoggerBlocObserver(logger: logger);
      bloc = MockBloc();
    });

    test('can be instantiated', () {
      expect(LoggerBlocObserver(), isNotNull);
    });

    group('onEvent', () {
      test('calls loggy.info', () {
        const event = 'event';
        observer.onEvent(bloc, event);
        verify(() => logger.i('onEvent - ${bloc.runtimeType} $event'));
      });
    });

    group('onChange', () {
      test('calls loggy.info', () {
        const change = Change<String>(
          currentState: 'currentState',
          nextState: 'nextState',
        );

        observer.onChange(bloc, change);

        verify(
          () => logger.i(
            'onChange - ${bloc.runtimeType} \n'
            'CurrentState: ${change.currentState} \n'
            'NextState: ${change.nextState}',
          ),
        );
      });
    });

    group('onCreate', () {
      test('calls loggy.info', () {
        observer.onCreate(bloc);

        verify(() => logger.i('${bloc.runtimeType} created'));
      });
    });

    group('onClose', () {
      test('calls loggy.info', () {
        observer.onClose(bloc);

        verify(() => logger.i('${bloc.runtimeType} closed'));
      });
    });

    group('onError', () {
      test('calls loggy.error', () {
        const error = 'error';
        final stackTrace = StackTrace.fromString('stackTrace');
        observer.onError(bloc, error, stackTrace);

        verify(() => logger.e('${bloc.runtimeType}', error, stackTrace));
      });
    });
  });
}
