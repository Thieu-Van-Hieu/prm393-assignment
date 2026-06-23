import 'dart:async';

import 'package:my_fschool_frontend/api/transcript_api.dart';
import 'package:my_fschool_frontend/model/response/semester_transcript_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transcript_notifier.g.dart';

@Riverpod(keepAlive: true)
class TranscriptNotifier extends _$TranscriptNotifier {
  final _transcriptApi = TranscriptApi();

  @override
  FutureOr<List<SemesterTranscriptResponse>> build() async {
    return [];
  }

  Future<void> fetchSemesterTranscripts({
    required String studentId,
    bool isSilent = false,
  }) async {
    if (!isSilent) {
      state = const AsyncLoading();
    }

    try {
      final records = await _transcriptApi.getTranscript(studentId: studentId);

      state = AsyncValue.data(records.data ?? []);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
