// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ScheduleNotifier)
final scheduleProvider = ScheduleNotifierProvider._();

final class ScheduleNotifierProvider
    extends $AsyncNotifierProvider<ScheduleNotifier, List<ScheduleResponse>> {
  ScheduleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleNotifierHash();

  @$internal
  @override
  ScheduleNotifier create() => ScheduleNotifier();
}

String _$scheduleNotifierHash() => r'48f2bd49aceaaeff6b8e3d1a2831b4f68d845ccc';

abstract class _$ScheduleNotifier
    extends $AsyncNotifier<List<ScheduleResponse>> {
  FutureOr<List<ScheduleResponse>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ScheduleResponse>>, List<ScheduleResponse>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ScheduleResponse>>,
                List<ScheduleResponse>
              >,
              AsyncValue<List<ScheduleResponse>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
