// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TranscriptNotifier)
final transcriptProvider = TranscriptNotifierProvider._();

final class TranscriptNotifierProvider
    extends
        $AsyncNotifierProvider<
          TranscriptNotifier,
          List<SemesterTranscriptResponse>
        > {
  TranscriptNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transcriptProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transcriptNotifierHash();

  @$internal
  @override
  TranscriptNotifier create() => TranscriptNotifier();
}

String _$transcriptNotifierHash() =>
    r'6033e1668433897385e12808b539e2d852a1c617';

abstract class _$TranscriptNotifier
    extends $AsyncNotifier<List<SemesterTranscriptResponse>> {
  FutureOr<List<SemesterTranscriptResponse>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<SemesterTranscriptResponse>>,
              List<SemesterTranscriptResponse>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SemesterTranscriptResponse>>,
                List<SemesterTranscriptResponse>
              >,
              AsyncValue<List<SemesterTranscriptResponse>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
