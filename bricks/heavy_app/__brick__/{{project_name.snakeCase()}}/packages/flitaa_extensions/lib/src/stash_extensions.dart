import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stash/stash_api.dart';

extension StashExtensions<T> on Cache<T> {
  /// Return a stream that emits events whenever the cache is updated.
  ///
  /// Make sure that the event listener mode for the cache is not none.
  Stream<T?> get stream {
    return on<CacheEntryUpdatedEvent<T>>()
        .map((event) => event.newEntry.value as T?);
  }

  /// Essentially return [stream] but seed with response from [initial].
  Stream<T?> streamSeeded(FutureOr<T?> Function() initial) {
    return ConcatStream([Rx.fromCallable(() => initial()), stream]);
  }
}
