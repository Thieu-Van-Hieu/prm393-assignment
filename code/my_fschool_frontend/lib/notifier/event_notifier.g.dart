// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventNotifier)
final eventProvider = EventNotifierProvider._();

final class EventNotifierProvider
    extends $AsyncNotifierProvider<EventNotifier, List<EventResponse>> {
  EventNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventNotifierHash();

  @$internal
  @override
  EventNotifier create() => EventNotifier();
}

String _$eventNotifierHash() => r'7ca3417e0319e2ce9bd637eb4710ae8180ee3c4d';

abstract class _$EventNotifier extends $AsyncNotifier<List<EventResponse>> {
  FutureOr<List<EventResponse>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<EventResponse>>, List<EventResponse>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<EventResponse>>, List<EventResponse>>,
              AsyncValue<List<EventResponse>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
