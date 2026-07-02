// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClubNotifier)
final clubProvider = ClubNotifierProvider._();

final class ClubNotifierProvider
    extends $AsyncNotifierProvider<ClubNotifier, StudentClubsResponse> {
  ClubNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clubProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clubNotifierHash();

  @$internal
  @override
  ClubNotifier create() => ClubNotifier();
}

String _$clubNotifierHash() => r'd69e000dfe607d5ee8932a91eb8024789aab94e5';

abstract class _$ClubNotifier extends $AsyncNotifier<StudentClubsResponse> {
  FutureOr<StudentClubsResponse> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<StudentClubsResponse>, StudentClubsResponse>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<StudentClubsResponse>,
                StudentClubsResponse
              >,
              AsyncValue<StudentClubsResponse>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
