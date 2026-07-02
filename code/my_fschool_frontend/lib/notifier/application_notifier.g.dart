// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ApplicationNotifier)
final applicationProvider = ApplicationNotifierProvider._();

final class ApplicationNotifierProvider
    extends
        $AsyncNotifierProvider<ApplicationNotifier, List<ApplicationResponse>> {
  ApplicationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applicationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applicationNotifierHash();

  @$internal
  @override
  ApplicationNotifier create() => ApplicationNotifier();
}

String _$applicationNotifierHash() =>
    r'83e96a07ca15534f62237a641b503d91542c9ba5';

abstract class _$ApplicationNotifier
    extends $AsyncNotifier<List<ApplicationResponse>> {
  FutureOr<List<ApplicationResponse>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ApplicationResponse>>,
              List<ApplicationResponse>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ApplicationResponse>>,
                List<ApplicationResponse>
              >,
              AsyncValue<List<ApplicationResponse>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
