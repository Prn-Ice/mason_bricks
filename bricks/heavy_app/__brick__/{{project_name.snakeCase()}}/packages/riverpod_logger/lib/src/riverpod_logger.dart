import 'package:crashlytics_service/crashlytics_service.dart';
import 'package:riverpod/riverpod.dart';
import 'package:talker/talker.dart';

/// {@template riverpod_logger}
/// Dart package for a riverpod observer that prints output using logger.
/// {@endtemplate}
class RiverpodLogger extends ProviderObserver {
  /// {@macro riverpod_logger}
  RiverpodLogger({
    required CrashlyticsService crashlyticsService,
    Talker? logger,
  })  : _logger = logger ?? Talker(),
        _crashlyticsService = crashlyticsService;

  final Talker _logger;
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

    _logger.verbose('$providerName created');
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
    _logger.verbose(log);
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

    _logger.verbose(message);
    _crashlyticsService.log(message);
  }
}
