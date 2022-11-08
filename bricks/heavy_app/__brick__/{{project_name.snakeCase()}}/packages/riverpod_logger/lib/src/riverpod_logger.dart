import 'package:crashlytics_service/crashlytics_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

/// {@template riverpod_logger}
/// Dart package for a riverpod observer that prints output using logger.
/// {@endtemplate}
class RiverpodLogger extends ProviderObserver {
  /// {@macro riverpod_logger}
  RiverpodLogger({
    Logger? logger,
    required CrashlyticsService crashlyticsService,
  })  : _logger = logger ?? Logger(),
        _crashlyticsService = crashlyticsService;

  final Logger _logger;
  final CrashlyticsService _crashlyticsService;

  @override
  void didAddProvider(
    ProviderBase<dynamic> provider,
    Object? value,
    ProviderContainer container,
  ) {
    final providerName = (provider.name ?? provider.runtimeType).toString();

    if (providerName.toLowerCase().contains('bloc') ||
        providerName.toLowerCase().contains('cubit')) {
      return;
    }

    _logger.v('$providerName created');
    _crashlyticsService.log('$providerName created');
  }

  @override
  void didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final providerName = (provider.name ?? provider.runtimeType).toString();

    if (providerName.toLowerCase().contains('bloc') ||
        providerName.toLowerCase().contains('cubit')) {
      return;
    }

    final log = {
      'method': 'didUpdateProvider',
      'provider': providerName,
      'previousValue': '$previousValue',
      'newValue': '$newValue',
    };
    _logger.v(log);
    _crashlyticsService.log(log.toString());
  }

  @override
  void didDisposeProvider(
    ProviderBase<dynamic> provider,
    ProviderContainer container,
  ) {
    final providerName = (provider.name ?? provider.runtimeType).toString();

    if (providerName.toLowerCase().contains('bloc') ||
        providerName.toLowerCase().contains('cubit')) {
      return;
    }

    final message = '${provider.name ?? provider.runtimeType} disposed';

    _logger.v(message);
    _crashlyticsService.log(message);
  }
}
