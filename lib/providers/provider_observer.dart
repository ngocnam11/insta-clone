import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/global_variables.dart';

class ProviderLogger extends ProviderObserver {
  const ProviderLogger();

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    log.i('${provider.name ?? provider.runtimeType} Added');
    super.didAddProvider(provider, value, container);
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    log.i(
      '${provider.name ?? provider.runtimeType} Updated\nPrevious: $previousValue\nNew: $newValue',
    );
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer container,
  ) {
    log.i('${provider.name ?? provider.runtimeType} Disposed');
    super.didDisposeProvider(provider, container);
  }

  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    log.e('${provider.name ?? provider.runtimeType} Failed\nError: $error');
    super.providerDidFail(provider, error, stackTrace, container);
  }
}
